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

export { drawPoints };
