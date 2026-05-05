/**
 * zoomRangerPlugin
 *
 * Creates an interactive range-selector (ranger) chart below the main uPlot
 * chart.  The two charts are kept in sync:
 *   - Dragging / resizing the ranger selection updates the main chart X scale.
 *   - Zooming / panning the main chart updates the ranger selection.
 *
 * @param {HTMLElement} el        - The widget container element.
 * @param {number}      width     - Initial width (px).
 * @param {number}      mainHeight - Height of the main (zoomed) chart (px).
 * @param {Array}       data      - uPlot data array.
 * @param {Object}      opts      - Options for the main chart.
 * @param {Object}      cfg       - Ranger-specific configuration from R.
 * @param {typeof uPlot} UPlot   - The uPlot constructor.
 * @returns {{ zoomed: uPlot, ranger: uPlot }}
 */
function createZoomRanger(el, width, mainHeight, data, opts, cfg, UPlot) {
  const rangerHeight = cfg.height || 80;
  const gripColor    = cfg.gripColor || "#4a90d9";
  const gripWidth    = cfg.gripWidth || 8;

  // ── Inject CSS once per document ──────────────────────────────────────────
  const CSS_ID = "u-zoom-ranger-styles";
  if (!document.getElementById(CSS_ID)) {
    const style = document.createElement("style");
    style.id = CSS_ID;
    style.textContent = [
      ".u-zoom-ranger-wrap { display: flex; flex-direction: column; width: 100%; height: 100%; }",
      ".u-zoom-ranger-wrap .u-zoom-ranger-main { flex: 1 1 auto; overflow: hidden; }",
      ".u-zoom-ranger-wrap .u-zoom-ranger-nav  { flex: 0 0 auto; overflow: hidden; }",
      ".u-zoom-ranger-wrap .u-zoom-ranger-nav .u-select { pointer-events: all; cursor: grab; }",
      ".u-zoom-ranger-wrap .u-zoom-ranger-nav .u-select:active { cursor: grabbing; }",
      ".u-zoom-ranger-wrap .u-zoom-ranger-nav .u-axis { pointer-events: none; }",
      ".u-grip-l, .u-grip-r {",
      "  position: absolute; top: 0; width: " + gripWidth + "px; height: 100%;",
      "  background: " + gripColor + "; opacity: 0.8; cursor: ew-resize; border-radius: 2px;",
      "}",
      ".u-grip-l { left:  " + (-Math.ceil(gripWidth / 2)) + "px; }",
      ".u-grip-r { right: " + (-Math.ceil(gripWidth / 2)) + "px; }",
    ].join("\n");
    document.head.appendChild(style);
  }

  // ── DOM structure ──────────────────────────────────────────────────────────
  const wrap     = document.createElement("div");
  wrap.className = "u-zoom-ranger-wrap";

  const mainEl   = document.createElement("div");
  mainEl.className = "u-zoom-ranger-main";

  const navEl    = document.createElement("div");
  navEl.className = "u-zoom-ranger-nav";

  wrap.appendChild(mainEl);
  wrap.appendChild(navEl);
  el.appendChild(wrap);

  // ── Shared state ───────────────────────────────────────────────────────────
  let x0, lft0, rgt0;
  const lftWid = { left: null, width: null };
  const minMax = { min: null, max: null };

  const BOUNDARY_LEFT  = 0;
  const BOUNDARY_RIGHT = 1;
  const BOUNDARY_BOTH  = 2;

  // Forward-declared so hooks can close over them safely.
  let uZoomed, uRanger;

  // ── Helpers ────────────────────────────────────────────────────────────────
  function debounce(fn) {
    let raf;
    return (...args) => {
      if (raf) return;
      raf = requestAnimationFrame(() => { fn(...args); raf = null; });
    };
  }

  function placeDiv(parent, cls) {
    const d = document.createElement("div");
    d.classList.add(cls);
    parent.appendChild(d);
    return d;
  }

  function selectRanger(newLft, newWid) {
    lftWid.left  = newLft;
    lftWid.width = newWid;
    uRanger.setSelect(lftWid, false);
  }

  function zoomMain(newLft, newWid) {
    minMax.min = uRanger.posToVal(newLft,          "x");
    minMax.max = uRanger.posToVal(newLft + newWid, "x");
    uZoomed.setScale("x", minMax);
  }

  function update(newLft, newRgt, movedBoundary) {
    const maxRgt = uRanger.bbox.width / uPlotPxRatio();

    if (movedBoundary === BOUNDARY_BOTH) {
      const initWidth = newRgt - newLft;
      if (newRgt > maxRgt) { newRgt = maxRgt; newLft = newRgt - initWidth; }
      else if (newLft < 0) { newLft = 0;      newRgt = newLft + initWidth; }
    } else {
      if (newLft > newRgt) {
        if (movedBoundary === BOUNDARY_LEFT)  newLft = newRgt;
        else if (movedBoundary === BOUNDARY_RIGHT) newRgt = newLft;
      }
      newLft = Math.max(0, newLft);
      newRgt = Math.min(newRgt, maxRgt);
    }
    zoomMain(newLft, newRgt - newLft);
  }

  function uPlotPxRatio() {
    // uPlot.pxRatio is a static property on the constructor
    return UPlot.pxRatio || window.devicePixelRatio || 1;
  }

  function bindMove(e, onMove) {
    x0   = e.clientX;
    lft0 = uRanger.select.left;
    rgt0 = lft0 + uRanger.select.width;

    const _onMove = debounce(onMove);
    document.addEventListener("mousemove", _onMove);

    function _onUp() {
      document.removeEventListener("mouseup",   _onUp);
      document.removeEventListener("mousemove", _onMove);
    }
    document.addEventListener("mouseup", _onUp);
    e.stopPropagation();
  }

  // ── Ranger series options ─────────────────────────────────────────────────
  const rangerSeries = opts.series
    ? opts.series.map((s, i) => {
        if (i === 0) return {};
        return { stroke: cfg.stroke || s.stroke || "#999" };
      })
    : [{}];

  // ── Ranger (navigator) chart options ──────────────────────────────────────
  const rangerOpts = {
    width:  width,
    height: rangerHeight,
    cursor: {
      x: false,
      y: false,
      points: { show: false },
      drag: { setScale: false, setSelect: true, x: true, y: false },
    },
    legend: { show: false },
    scales: opts.scales ? JSON.parse(JSON.stringify(opts.scales)) : {},
    axes: [
      {},
      { show: false, grid: { show: false }, ticks: { show: false } },
    ],
    series: rangerSeries,
    hooks: {
      ready: [
        (u) => {
          // Full selection initially (shows all data)
          const selLeft  = 0;
          const selWidth = u.bbox.width / uPlotPxRatio();
          const selHeight = u.bbox.height / uPlotPxRatio();
          u.setSelect({ left: selLeft, width: selWidth, height: selHeight }, false);

          const sel = u.root.querySelector(".u-select");

          sel.addEventListener("mousedown", (e) => {
            bindMove(e, (ev) =>
              update(lft0 + (ev.clientX - x0), rgt0 + (ev.clientX - x0), BOUNDARY_BOTH)
            );
          });

          placeDiv(sel, "u-grip-l").addEventListener("mousedown", (e) => {
            bindMove(e, (ev) =>
              update(lft0 + (ev.clientX - x0), rgt0, BOUNDARY_LEFT)
            );
          });

          placeDiv(sel, "u-grip-r").addEventListener("mousedown", (e) => {
            bindMove(e, (ev) =>
              update(lft0, rgt0 + (ev.clientX - x0), BOUNDARY_RIGHT)
            );
          });
        },
      ],
      setSelect: [
        (u) => {
          // Ranger drag/select → zoom main chart
          zoomMain(u.select.left, u.select.width);
        },
      ],
    },
  };

  // ── Main (zoomed) chart options ────────────────────────────────────────────
  // Merge original hooks with our setScale sync hook.
  const origHooks   = opts.hooks || {};
  const origSetScale = Array.isArray(origHooks.setScale)
    ? origHooks.setScale
    : origHooks.setScale
      ? [origHooks.setScale]
      : [];

  const zoomedOpts = Object.assign({}, opts, {
    width:  width,
    height: mainHeight,
    select: { over: false },
    hooks: Object.assign({}, origHooks, {
      setScale: [
        ...origSetScale,
        (u) => {
          // Main chart X scale changed → update ranger selection
          if (!uRanger) return;
          const left  = Math.round(uRanger.valToPos(u.scales.x.min, "x"));
          const right = Math.round(uRanger.valToPos(u.scales.x.max, "x"));
          selectRanger(left, right - left);
        },
      ],
    }),
  });

  // ── Create charts ──────────────────────────────────────────────────────────
  // Ranger first so that uRanger is defined before uZoomed's setScale fires.
  uRanger = new UPlot(rangerOpts, data, navEl);
  uZoomed = new UPlot(zoomedOpts, data, mainEl);

  // ── Resize observer ────────────────────────────────────────────────────────
  const resizeObserver = new ResizeObserver((entries) => {
    for (const entry of entries) {
      const newWidth = entry.contentRect.width;
      const newTotalHeight = entry.contentRect.height;
      const newMainHeight  = Math.max(50, newTotalHeight - rangerHeight - 4);
      uRanger.setSize({ width: newWidth, height: rangerHeight });
      uZoomed.setSize({ width: newWidth, height: newMainHeight });
    }
  });
  resizeObserver.observe(el);

  return { zoomed: uZoomed, ranger: uRanger, wrap: wrap };
}

export { createZoomRanger };
