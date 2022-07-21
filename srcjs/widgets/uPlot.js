import "widgets";
import uPlot from "uplot";
import "uplot/dist/uPlot.min.css";

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
      },

      resize: function(width, height) {
        plot.setSize({
          height: height,
          width: width
        });
      }

    };
  }
});
