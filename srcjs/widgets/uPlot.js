import "widgets";
import uPlot from "uplot";
import "uplot/dist/uPlot.min.css";

const resize = (plot, width, height) => {
  let adjHeight = height;
  const extras = plot.root.querySelectorAll(".u-legend, .u-title");
  extras.forEach(box => {
    adjHeight -= Math.floor(box.offsetHeight);
  });
  plot.setSize({ width: width, height: adjHeight });
};

HTMLWidgets.widget({
  name: "uPlot",

  type: "output",

  factory: function(el, width, height) {
    var plot, options, data;

    return {
      renderValue: function(x) {
        options = x.options;
        options.width = width;
        options.height = height;
        data = x.data;
        plot = new uPlot(options, data, el);
        setTimeout(function() {
          resize(plot, width, height);
        }, 500);
      },

      resize: function(width, height) {
        resize(plot, width, height);
      }
    };
  }
});

