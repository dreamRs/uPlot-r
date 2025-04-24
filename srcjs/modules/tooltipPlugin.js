const tooltipPlugin = (
  formatDate = "{YYYY}/{MM}/{DD} {HH}:{mm}:{ss}",
  separator = " - ",
  shiftX = 10,
  shiftY = 10,
) => {
  let tooltipLeftOffset = 0;
  let tooltipTopOffset = 0;

  const tooltip = document.createElement("div");
  tooltip.className = "u-tooltip";
  tooltip.style.position = "absolute";
  tooltip.style.display = "none";
  tooltip.style.padding = "4px";
  tooltip.style.border = "2px solid black";
  tooltip.style.background = "#FFF";

  let seriesIdx = null;
  let dataIdx = null;

  const fmtDate = uPlot.fmtDate(formatDate);

  let over;

  let tooltipVisible = false;

  function showTooltip() {
    if (!tooltipVisible) {
      tooltip.style.display = "block";
      over.style.cursor = "crosshair";
      tooltipVisible = true;
    }
  }

  function hideTooltip() {
    if (tooltipVisible) {
      tooltip.style.display = "none";
      over.style.cursor = null;
      tooltipVisible = false;
    }
  }

  function setTooltip(u) {
    console.log(u);
    showTooltip();

    let top = u.valToPos(u.data[seriesIdx][dataIdx], "y");
    let lft = u.valToPos(u.data[0][dataIdx], "x");

    tooltip.style.top = tooltipTopOffset + top + shiftX + "px";
    tooltip.style.left = tooltipLeftOffset + lft + shiftY + "px";

    let serieColor = u.series[seriesIdx]._stroke;
    tooltip.style.borderColor = serieColor;
    let value = u.series[seriesIdx].value;
    tooltip.textContent =
      fmtDate(new Date(u.data[0][dataIdx] * 1e3)) +
      separator +
      value(u, u.data[seriesIdx][dataIdx], seriesIdx, dataIdx); // uPlot.fmtNum()
  }

  return {
    hooks: {
      ready: [
        (u) => {
          over = u.over;
          tooltipLeftOffset = parseFloat(over.style.left);
          tooltipTopOffset = parseFloat(over.style.top);
          u.root.querySelector(".u-wrap").appendChild(tooltip);
        },
      ],
      setCursor: [
        (u) => {
          let c = u.cursor;

          if (dataIdx != c.idx) {
            dataIdx = c.idx;

            if (seriesIdx != null) setTooltip(u);
          }
        },
      ],
      setSeries: [
        (u, sidx) => {
          if (seriesIdx != sidx) {
            seriesIdx = sidx;

            if (sidx == null) hideTooltip();
            else if (dataIdx != null) setTooltip(u);
          }
        },
      ],
      drawAxes: [
        (u) => {
          let { ctx } = u;
          let { left, top, width, height } = u.bbox;

          const interpolatedColorWithAlpha = "#fcb0f17a";

          ctx.save();

          ctx.strokeStyle = interpolatedColorWithAlpha;
          ctx.beginPath();

          let [i0, i1] = u.series[0].idxs;

          ctx.closePath();
          ctx.stroke();
          ctx.restore();
        },
      ],
    },
  };
};


export { tooltipPlugin };
