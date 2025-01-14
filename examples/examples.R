library(uPlot)



# Cursor Focus ------------------------------------------------------------

# JS demo : https://leeoniya.github.io/uPlot/demos/focus-cursor.html
# JS code : https://github.com/leeoniya/uPlot/blob/master/demos/focus-cursor.html

uPlot(
  data = eco2mix[1:150, c(1, 3:11)],
  options = list(
    title = "Focus serie",
    hooks = list(
      setSeries = list(
        JS(
          "(u, seriesIdx) => {
								console.log('focus!', seriesIdx);
								u.series.forEach((s, i) => {
									s.width = i == seriesIdx ? 4 : 1;
								});
							}"
        )
      )
    ),
    focus = list(alpha = 0.9),
    cursor = list(
      focus = list(
        prox = 1e6,
        bias = 1,
        dist = JS(
          "(self, seriesIdx, dataIdx, valPos, curPos) => {
							//	if (seriesIdx == 4) {
							//		console.log('omit focus!');
							//		return Infinity;
							//	}
								return valPos - curPos;
							}"
        )
      )
    )
  )
) 