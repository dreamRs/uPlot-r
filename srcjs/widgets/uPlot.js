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
const resizer = (el, opts) => {
  const init = (u, init) => {
    let adjHeight = opts.height;
    let adjWidth = opts.width;

    const myObserver0 = new ResizeObserver(entries => {
      adjHeight = entries[0].contentRect.height;
      adjWidth = entries[0].contentRect.width;
      const extras = u.root.querySelectorAll('.u-legend, .u-title');
      for (let extra of extras) {
        adjHeight -= Math.floor(extra.offsetHeight);
      }
      console.log("Height: " + adjHeight);
      console.log("Width: " + adjWidth);
      u.setSize({ width: adjWidth, height: adjHeight });
    });
    const myObserver = new ResizeObserver(entries => {
      for (let entry of entries) {
        if (entry.target.classList.contains("u-legend") | entry.target.classList.contains("u-title")) {
          adjHeight -= Math.floor(entry.contentRect.height);
        }
      }
      u.setSize({ width: adjWidth, height: adjHeight });
    });

    const extras = u.root.querySelectorAll('.u-legend, .u-title');

    extras.forEach(box => {
      //myObserver.observe(box);
    });

    myObserver0.observe(el);
    //myObserver.observe(el);
    el.appendChild(u.root);
    init();
  };
  return init;
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
        plot = new uPlot(options, data, resizer(el, options));
        //setTimeout(function() {
        //  resize(plot, width, height);
        //}, 500);
      },

      resize: function(width, height) {
        //resize(plot, width, height);
      }
    };
  }
});

