import "widgets";
import uPlot from "uplot";
import "uplot/dist/uPlot.min.css";
import * as utils from "../modules/utils";
import { stackedChart } from "../modules/stack";
import { tooltipPlugin } from "../modules/tooltipPlugin";
import { legendAsTooltipPlugin } from "../modules/legendAsTooltipPlugin";
import { wheelZoomPlugin } from "../modules/wheelZoomPlugin";
import { columnHighlightPlugin } from "../modules/columnHighlightPlugin";
import { drawPoints } from "../modules/drawPoints";
import { drawHLine, drawVLine, drawVRect, drawHRect } from "../modules/draw";
import { candlestickPlugin } from "../modules/candlestickPlugin";
import { ungzip } from "pako";
import * as dayjs from "dayjs";
import utc from "dayjs/plugin/utc";
import timezone from "dayjs/plugin/timezone";
dayjs.extend(utc);
dayjs.extend(timezone);

const resizer = (el) => {
  const func = (u, init) => {
    const resizeObserver = new ResizeObserver((entries) => {
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

HTMLWidgets.widget({
  name: "uPlot",

  type: "output",

  factory: function (el, width, height) {
    var plot, options, data;

    return {
      renderValue: function (x) {
        if (typeof plot !== "undefined") {
          plot.destroy();
        }
        options = x.config.options;
        options.width = width;
        options.height = height;
        data = x.config.data;
        if (x.use_gzipped_json) {
          const gezipedData = atob(data);
          const gzipedDataArray = Uint8Array.from(gezipedData, (c) =>
            c.charCodeAt(0),
          );
          const ungzipedData = ungzip(gzipedDataArray);
          const decodedData = new TextDecoder().decode(ungzipedData);
          data = JSON.parse(decodedData);
        }
        //console.log(data);
        if (x.stacked) {
          if (!options.hooks) options.hooks = {};
          options.hooks.init = [
            (u) => {
              [...u.root.querySelectorAll(".u-legend .u-series")].forEach(
                (el, i) => {
                  if (u.series[i]._hide) {
                    el.style.display = "none";
                  }
                },
              );
            },
          ];
          plot = stackedChart(
            options.title,
            options.series,
            data,
            null,
            width,
            height,
            options.hooks,
            resizer(el),
          );
        } else {
          plot = new uPlot(options, data, resizer(el));
        }
      },
      getWidget: function () {
        return plot;
      },
      resize: function (width, height) {},
    };
  },
});

if (HTMLWidgets.shinyMode) {
  Shiny.addCustomMessageHandler("uplot-api", function (obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot[obj.name].apply(null, obj.args);
    }
  });
  Shiny.addCustomMessageHandler("uplot-setData", function (obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.setData(obj.data);
    }
  });
  Shiny.addCustomMessageHandler("uplot-setSeries", function (obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.setSeries(obj.seriesIdx, obj.options);
    }
  });
  Shiny.addCustomMessageHandler("uplot-addSeries", function (obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.addSeries(obj.options, obj.seriesIdx);
    }
  });
  Shiny.addCustomMessageHandler("uplot-delSeries", function (obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.delSeries(obj.seriesIdx);
    }
  });
  Shiny.addCustomMessageHandler("uplot-setScale", function (obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.setScale(obj.scaleKey, obj.limits);
    }
  });
  Shiny.addCustomMessageHandler("uplot-redraw", function (obj) {
    var plot = utils.getWidget(obj.id);
    if (typeof plot != "undefined") {
      plot.redraw(obj.rebuildPaths, obj.recalcAxes);
    }
  });
}

export {
  uPlot,
  drawPoints,
  drawHLine,
  drawVLine,
  drawVRect,
  drawHRect,
  wheelZoomPlugin,
  tooltipPlugin,
  legendAsTooltipPlugin,
  columnHighlightPlugin,
  candlestickPlugin,
  dayjs,
};
