
const drawHLine = (opts) => {
  let yintercept = opts.yintercept || 0;
  let color = opts.color || "#000";
  let width = opts.width || 1;
  let dash = opts.dash || [];
  const func = (u) => {
    let y = u.valToPos(yintercept, "y", true);
    let xl = u.valToPos(u.scales.x.min, "x", true);
    let xr = u.valToPos(u.scales.x.max, "x", true);
    u.ctx.save();
    u.ctx.beginPath();
    u.ctx.moveTo(xl, y);
    u.ctx.lineTo(xr, y);
    u.ctx.strokeStyle = color;
    u.ctx.lineWidth = width;
    u.ctx.setLineDash(dash);
    u.ctx.stroke();
    u.ctx.restore();
  };
  return func;
};


const drawVLine = (opts) => {
  let xintercept = opts.xintercept || 0;
  let color = opts.color || "#000";
  let width = opts.width || 1;
  let dash = opts.dash || [];
  const func = (u) => {
    let x = u.valToPos(xintercept, "x", true);
    let yb = u.valToPos(u.scales.y.min, "y", true);
    let yt = u.valToPos(u.scales.y.max, "y", true);
    u.ctx.save();
    u.ctx.beginPath();
    u.ctx.moveTo(x, yt);
    u.ctx.lineTo(x, yb);
    u.ctx.strokeStyle = color;
    u.ctx.lineWidth = width;
    u.ctx.setLineDash(dash);
    u.ctx.stroke();
    u.ctx.restore();
  };
  return func;
};


const drawVRect = (opts) => {
  let xmin = opts.xmin || 0;
  let xmax = opts.xmax || 0;
  let fill = opts.fill || "#848484";
  let alpha = opts.alpha || 0.1;
  const func = (u) => {
    let yt = u.valToPos(u.scales.y.max, "y", true);
    let yb = u.valToPos(u.scales.y.min, "y", true);
    let xl = u.valToPos(xmin, "x", true);
    let xr = u.valToPos(xmax, "x", true);
    u.ctx.save();
    u.ctx.beginPath();
    u.ctx.fillStyle = fill;
    u.ctx.globalAlpha = alpha;
    u.ctx.fillRect(xl, yt, xr - xl, yb - yt);
    u.ctx.restore();
  };
  return func;
};


const drawHRect = (opts) => {
  let ymin = opts.ymin || 0;
  let ymax = opts.ymax || 0;
  let fill = opts.fill || "#848484";
  let alpha = opts.alpha || 0.1;
  const func = (u) => {
    let yb = u.valToPos(ymin, "y", true);
    let yt = u.valToPos(ymax, "y", true);
    let xl = u.valToPos(u.scales.x.min, "x", true);
    let xr = u.valToPos(u.scales.x.max, "x", true);
    u.ctx.save();
    u.ctx.beginPath();
    u.ctx.fillStyle = fill;
    u.ctx.globalAlpha = alpha;
    u.ctx.fillRect(xl, yt, xr - xl, yb - yt);
    u.ctx.restore();
  };
  return func;
};


export { drawHLine, drawVLine, drawVRect, drawHRect };
