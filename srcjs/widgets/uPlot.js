import "widgets";
import uPlot from "uplot";
import "uplot/dist/uPlot.min.css";
import * as utils from "../modules/utils";
import { stackedChart } from "../modules/stack";
import { ungzip } from "pako";
import Quadtree from "@timohausmann/quadtree-js";

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

let pxRatio;
let qt;
function setPxRatio() {
  pxRatio = uPlot.pxRatio;
}
setPxRatio();
window.addEventListener("dppxchange", setPxRatio);
// size range in pixels (diameter)
let minSize = 6;
let maxSize = 60;

let maxArea = Math.PI * (maxSize / 2) ** 2;
let minArea = Math.PI * (minSize / 2) ** 2;

// quadratic scaling (px area)
function getSize(value, minValue, maxValue) {
  let pct = value / maxValue;
  // clamp to min area
  //let area = Math.max(maxArea * pct, minArea);
  let area = maxArea * pct;
  return Math.sqrt(area / Math.PI) * 2;
}

function getSizeMinMax(u) {
  let minValue = Infinity;
  let maxValue = -Infinity;

  for (let i = 1; i < u.series.length; i++) {
    let sizeData = u.data[i][2];

    for (let j = 0; j < sizeData.length; j++) {
      minValue = Math.min(minValue, sizeData[j]);
      maxValue = Math.max(maxValue, sizeData[j]);
    }
  }

  return [minValue, maxValue];
}

const drawClear3 = u => {
  qt = qt || new Quadtree(0, 0, u.bbox.width, u.bbox.height);

  qt.clear();

  // force-clear the path cache to cause drawBars() to rebuild new quadtree
  u.series.forEach((s, i) => {
    if (i > 0) s._paths = null;
  });
};

const makeDrawPoints3 = opts => {
  let { /*size,*/ disp, each = () => {} } = opts;

  return (u, seriesIdx, idx0, idx1) => {
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

        let strokeWidth = 1;

        u.ctx.save();

        u.ctx.rect(u.bbox.left, u.bbox.top, u.bbox.width, u.bbox.height);
        u.ctx.clip();

        u.ctx.fillStyle = series.fill();
        u.ctx.strokeStyle = series.stroke();
        u.ctx.lineWidth = strokeWidth;

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

        // compute bubble dims
        let sizes = disp.size.values(u, seriesIdx, idx0, idx1);

        // todo: this depends on direction & orientation
        // todo: calc once per redraw, not per path
        let filtLft = u.posToVal(-maxSize / 2, scaleX.key);
        let filtRgt = u.posToVal(
          u.bbox.width / pxRatio + maxSize / 2,
          scaleX.key
        );
        let filtBtm = u.posToVal(
          u.bbox.height / pxRatio + maxSize / 2,
          scaleY.key
        );
        let filtTop = u.posToVal(-maxSize / 2, scaleY.key);

        for (let i = 0; i < d[0].length; i++) {
          let xVal = d[0][i];
          let yVal = d[1][i];
          let size = sizes[i] * pxRatio;

          if (
            xVal >= filtLft &&
            xVal <= filtRgt &&
            yVal >= filtBtm &&
            yVal <= filtTop
          ) {
            let cx = valToPosX(xVal, scaleX, xDim, xOff);
            let cy = valToPosY(yVal, scaleY, yDim, yOff);

            u.ctx.moveTo(cx + size / 2, cy);
            u.ctx.beginPath();
            u.ctx.arc(cx, cy, size / 2, 0, deg360);
            u.ctx.fill();
            u.ctx.stroke();

            each(
              u,
              seriesIdx,
              i,
              cx - size / 2 - strokeWidth / 2,
              cy - size / 2 - strokeWidth / 2,
              size + strokeWidth,
              size + strokeWidth
            );
          }
        }

        console.timeEnd("points");

        u.ctx.restore();
      }
    );

    return null;
  };
};

let drawPoints3 = makeDrawPoints3({
  disp: {
    size: {
      unit: 3, // raw CSS pixels
      //	discr: true,
      values: (u, seriesIdx, idx0, idx1) => {
        // TODO: only run once per setData() call
        let [minValue, maxValue] = getSizeMinMax(u);
        return u.data[seriesIdx][2].map(v => getSize(v, minValue, maxValue));
      }
    }
  },
  each: (u, seriesIdx, dataIdx, lft, top, wid, hgt) => {
    // we get back raw canvas coords (included axes & padding). translate to the plotting area origin
    lft -= u.bbox.left;
    top -= u.bbox.top;
    qt.add({ x: lft, y: top, w: wid, h: hgt, sidx: seriesIdx, didx: dataIdx });
  }
});



HTMLWidgets.widget({
  name: "uPlot",

  type: "output",

  factory: function(el, width, height) {
    let plot, options, data;

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
          const gzipedDataArray = Uint8Array.from(gezipedData, c =>
            c.charCodeAt(0)
          );
          const ungzipedData = ungzip(gzipedDataArray);
          const decodedData = new TextDecoder().decode(ungzipedData);
          data = JSON.parse(decodedData);
        }
        console.log(data);
        if (x.stacked) {
          if (!options.hooks) options.hooks = {};
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
}

export { uPlot, drawPoints, drawPoints3, drawClear3 };

