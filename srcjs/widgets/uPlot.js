import "widgets";
import uPlot from "uplot";
import "uplot/dist/uPlot.min.css";
import * as utils from "../modules/utils";

const resizer = (el) => {
  const func = (u, init) => {
    const resizeObserver = new ResizeObserver(entries => {
      for (let entry of entries) {
        let adjHeight = entry.contentRect.height;
        let adjWidth = entry.contentRect.width;
        const extras = u.root.querySelectorAll('.u-legend, .u-title');
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
