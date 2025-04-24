import "widgets";
import uPlot from "uplot";
import "uplot/dist/uPlot.min.css";
import * as utils from "../modules/utils";
import { stackedChart } from "../modules/stack";
import { tooltipPlugin } from "../modules/tooltipPlugin";
import { ungzip } from "pako";

const resizer = el => {
  const func = (u, init) => {
    const resizeObserver = new ResizeObserver(entries => {
      for (let entry of entries) {
        let adjHeight = entry.contentRect.height;
        let adjWidth = entry.contentRect.width;
        const extras = u.root.querySelectorAll(".u-legend, .u-title");
        for (let extra of extras) {
          adjHeight -= Math.floor(extra.offsetHeight);
        }
        u.setSize({ width: adjWidth, height: adjHeight });
      }
    });
    resizeObserver.observe(el);
    el.appendChild(u.root);
    init();
  };
  return func;
};

const drawPoints = (u, seriesIdx, idx0, idx1) => {
  const size = 5 * devicePixelRatio;

  uPlot.orient(
    u,
    seriesIdx,
    (
      series,
      dataX,
      dataY,
      scaleX,
      scaleY,
      valToPosX,
      valToPosY,
      xOff,
      yOff,
      xDim,
      yDim,
      moveTo,
      lineTo,
      rect,
      arc
    ) => {
      let d = u.data[seriesIdx];

      u.ctx.fillStyle = series.stroke();

      let deg360 = 2 * Math.PI;

      console.time("points");

      //	let cir = new Path2D();
      //	cir.moveTo(0, 0);
      //	arc(cir, 0, 0, 3, 0, deg360);

      // Create transformation matrix that moves 200 points to the right
      //	let m = document.createElementNS('http://www.w3.org/2000/svg', 'svg').createSVGMatrix();
      //	m.a = 1;   m.b = 0;
      //	m.c = 0;   m.d = 1;
      //	m.e = 200; m.f = 0;

      let p = new Path2D();

      for (let i = 0; i < d[0].length; i++) {
        let xVal = d[0][i];
        let yVal = d[1][i];

        if (
          xVal >= scaleX.min &&
          xVal <= scaleX.max &&
          yVal >= scaleY.min &&
          yVal <= scaleY.max
        ) {
          let cx = valToPosX(xVal, scaleX, xDim, xOff);
          let cy = valToPosY(yVal, scaleY, yDim, yOff);

          p.moveTo(cx + size / 2, cy);
          //	arc(p, cx, cy, 3, 0, deg360);
          arc(p, cx, cy, size / 2, 0, deg360);

          //	m.e = cx;
          //	m.f = cy;
          //	p.addPath(cir, m);

          //	qt.add({x: cx - 1.5, y: cy - 1.5, w: 3, h: 3, sidx: seriesIdx, didx: i});
        }
      }

      console.timeEnd("points");

      u.ctx.fill(p);
    }
  );

  return null;
};

const wheelZoomPlugin = (opts) => {
  let factor = opts.factor || 0.75;

  let xMin, xMax, yMin, yMax, xRange, yRange;

  function clamp(nRange, nMin, nMax, fRange, fMin, fMax) {
    if (nRange > fRange) {
      nMin = fMin;
      nMax = fMax;
    } else if (nMin < fMin) {
      nMin = fMin;
      nMax = fMin + nRange;
    } else if (nMax > fMax) {
      nMax = fMax;
      nMin = fMax - nRange;
    }

    return [nMin, nMax];
  }

  return {
    hooks: {
      ready: (u) => {
        xMin = u.scales.x.min;
        xMax = u.scales.x.max;
        yMin = u.scales.y.min;
        yMax = u.scales.y.max;

        xRange = xMax - xMin;
        yRange = yMax - yMin;

        let over = u.over;
        let rect = over.getBoundingClientRect();

        // wheel drag pan
        over.addEventListener("mousedown", (e) => {
          if (e.button == 1) {
            //	plot.style.cursor = "move";
            e.preventDefault();

            let left0 = e.clientX;
            //	let top0 = e.clientY;

            let scXMin0 = u.scales.x.min;
            let scXMax0 = u.scales.x.max;

            let xUnitsPerPx = u.posToVal(1, "x") - u.posToVal(0, "x");

            function onmove(e) {
              e.preventDefault();

              let left1 = e.clientX;
              //	let top1 = e.clientY;

              let dx = xUnitsPerPx * (left1 - left0);

              u.setScale("x", {
                min: scXMin0 - dx,
                max: scXMax0 - dx,
              });
            }

            function onup(e) {
              document.removeEventListener("mousemove", onmove);
              document.removeEventListener("mouseup", onup);
            }

            document.addEventListener("mousemove", onmove);
            document.addEventListener("mouseup", onup);
          }
        });

        // wheel scroll zoom
        over.addEventListener("wheel", (e) => {
          e.preventDefault();

          let { left, top } = u.cursor;

          let leftPct = left / rect.width;
          let btmPct = 1 - top / rect.height;
          let xVal = u.posToVal(left, "x");
          let yVal = u.posToVal(top, "y");
          let oxRange = u.scales.x.max - u.scales.x.min;
          let oyRange = u.scales.y.max - u.scales.y.min;

          let nxRange = e.deltaY < 0 ? oxRange * factor : oxRange / factor;
          let nxMin = xVal - leftPct * nxRange;
          let nxMax = nxMin + nxRange;
          [nxMin, nxMax] = clamp(nxRange, nxMin, nxMax, xRange, xMin, xMax);

          let nyRange = e.deltaY < 0 ? oyRange * factor : oyRange / factor;
          let nyMin = yVal - btmPct * nyRange;
          let nyMax = nyMin + nyRange;
          [nyMin, nyMax] = clamp(nyRange, nyMin, nyMax, yRange, yMin, yMax);

          u.batch(() => {
            u.setScale("x", {
              min: nxMin,
              max: nxMax,
            });

            u.setScale("y", {
              min: nyMin,
              max: nyMax,
            });
          });
        });
      },
    },
  };
};


HTMLWidgets.widget({
  name: "uPlot",

  type: "output",

  factory: function(el, width, height) {
    var plot, options, data;

    return {
      renderValue: function(x) {
        if (typeof plot !== "undefined") {
          plot.destroy();
        }
        options = x.config.options;
        options.width = width;
        options.height = height;
        data = x.config.data;
        if (x.use_gzipped_json) {
          const gezipedData = atob(data);
          const gzipedDataArray = Uint8Array.from(gezipedData, c => c.charCodeAt(0));
          const ungzipedData = ungzip(gzipedDataArray);
          const decodedData = new TextDecoder().decode(ungzipedData);
          data = JSON.parse(decodedData);
        }
        //console.log(data);
        if (x.stacked) {
          if (!options.hooks)
            options.hooks = {};
          options.hooks.init = [
            u => {
              [...u.root.querySelectorAll(".u-legend .u-series")].forEach(
                (el, i) => {
                  if (u.series[i]._hide) {
                    el.style.display = "none";
                  }
                }
              );
            }
          ];
          plot = stackedChart(
            options.title,
            options.series,
            data,
            null,
            width,
            height,
            options.hooks,
            resizer(el)
          );
        } else {
          plot = new uPlot(options, data, resizer(el));
        }
      },
      getWidget: function() {
        return plot;
      },
      resize: function(width, height) {}
    };
  }
});

if (HTMLWidgets.shinyMode) {
  Shiny.addCustomMessageHandler("uplot-api", function(obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot[obj.name].apply(null, obj.args);
    }
  });
  Shiny.addCustomMessageHandler("uplot-setData", function(obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.setData(obj.data);
    }
  });
  Shiny.addCustomMessageHandler("uplot-setSeries", function(obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.setSeries(obj.seriesIdx, obj.options);
    }
  });
  Shiny.addCustomMessageHandler("uplot-addSeries", function(obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.addSeries(obj.options, obj.seriesIdx);
    }
  });
  Shiny.addCustomMessageHandler("uplot-delSeries", function(obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.delSeries(obj.seriesIdx);
    }
  });
  Shiny.addCustomMessageHandler("uplot-setScale", function(obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.setScale(obj.scaleKey, obj.limits);
    }
  });
  Shiny.addCustomMessageHandler("uplot-redraw", function(obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.redraw(obj.rebuildPaths, obj.recalcAxes);
    }
  });
}

export { uPlot, drawPoints, wheelZoomPlugin, tooltipPlugin };

