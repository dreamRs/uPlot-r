import "widgets";
import uPlot from "uplot";
import "uplot/dist/uPlot.min.css";
import * as utils from "../modules/utils";

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
        options = x.options;
        options.width = width;
        options.height = height;
        data = x.data;
        plot = new uPlot(options, data, resizer(el));
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


export { uPlot, drawPoints };
