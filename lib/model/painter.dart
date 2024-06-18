import 'package:flutter/material.dart';

enum Styles {
  styleTopRight,
  styleLowerRight,
}

class Painter {
  // 容器大小
  Size size = const Size(300, 300);
  // 控制点（手指触摸点）
  Offset offset = const Offset(0, 0);

  Styles style = Styles.styleLowerRight;

  double ax = 0, ay = 0;
  double bx = 0, by = 0;
  double cx = 0, cy = 0;
  double jx = 0, jy = 0;
  double ex = 0, ey = 0;
  double hx = 0, hy = 0;
  double gx = 0, gy = 0;
  double fx = 0, fy = 0;
  double kx = 0, ky = 0;
  double ix = 0, iy = 0;
  double dx = 0, dy = 0;

  Offset f = const Offset(0, 0);
  Offset g = const Offset(0, 0);
  Offset e = const Offset(0, 0);
  Offset h = const Offset(0, 0);
  Offset c = const Offset(0, 0);
  Offset j = const Offset(0, 0);
  Offset b = const Offset(0, 0);
  Offset k = const Offset(0, 0);
  Offset i = const Offset(0, 0);
  Offset d = const Offset(0, 0);

  Paint pathAPaint = Paint()
    ..color = Colors.green
    ..isAntiAlias = true;

  Paint pathBPaint = Paint()
    ..color = Colors.red
    ..isAntiAlias = true;

  Paint pathCPaint = Paint()
    ..color = Colors.blue
    ..isAntiAlias = true;

  Path pathA = Path();
  Path pathB = Path();
  Path pathC = Path();

  Painter(this.offset, this.size, this.style) {
    print('style: $style');

    // switch (style) {
    //   case Styles.styleTopRight:
    //     fy = size.height;
    //     break;
    //   case Styles.styleLowerRight:
    //     fy = 0;
    //     break;
    // }
    // a dot
    ax = offset.dx;
    ay = offset.dy;
    // f dot
    fx = size.width;
    fy = size.height;
    f = Offset(fx, fy); // 边缘角点
    // g dot
    gx = (ax + fx) / 2;
    gy = (ay + fy) / 2;
    g = Offset(gx, gy);
    // e dot
    ex = gx - (fy - gy) * (fy - gy) / (fx - gx);
    ey = fy;
    e = Offset(ex, ey);
    // h dot
    hx = fx;
    hy = gy - (fx - gx) * (fx - gx) / (fy - gy);
    h = Offset(hx, hy);

    cx = ex - (fx - ex) / 2;
    cy = fy;
    c = Offset(cx, cy);
    jx = fx;
    jy = hy - (fy - hy) / 2;
    j = Offset(jx, jy);

    b = getCrossPoint(
        Offset(ax, ay), Offset(ex, ey), Offset(cx, cy), Offset(jx, jy));
    bx = b.dx;
    by = b.dy;
    k = getCrossPoint(
        Offset(ax, ay), Offset(hx, hy), Offset(cx, cy), Offset(jx, jy));
    kx = k.dx;
    ky = k.dy;

    dx = (cx + 2 * ex + bx) / 4;
    dy = (2 * ey + cy + by) / 4;
    d = Offset(dx, dy);
    ix = (jx + 2 * hx + kx) / 4;
    iy = (2 * hy + jy + ky) / 4;
    i = Offset(ix, iy);
    pathA = getPathA();
    pathB = getPathB();
    pathC = getPathC();
  }

  Offset getCrossPoint(Offset lineOneMyPointOne, Offset lineOneMyPointTwo,
      Offset lineTwoMyPointOne, Offset lineTwoMyPointTwo) {
    double x1, y1, x2, y2, x3, y3, x4, y4;
    x1 = lineOneMyPointOne.dx;
    y1 = lineOneMyPointOne.dy;
    x2 = lineOneMyPointTwo.dx;
    y2 = lineOneMyPointTwo.dy;
    x3 = lineTwoMyPointOne.dx;
    y3 = lineTwoMyPointOne.dy;
    x4 = lineTwoMyPointTwo.dx;
    y4 = lineTwoMyPointTwo.dy;

    double pointX =
        ((x1 - x2) * (x3 * y4 - x4 * y3) - (x3 - x4) * (x1 * y2 - x2 * y1)) /
            ((x3 - x4) * (y1 - y2) - (x1 - x2) * (y3 - y4));
    double pointY =
        ((y1 - y2) * (x3 * y4 - x4 * y3) - (x1 * y2 - x2 * y1) * (y3 - y4)) /
            ((y1 - y2) * (x3 - x4) - (x1 - x2) * (y3 - y4));

    return Offset(pointX, pointY);
  }

  Path getPathAFromTopRight() {
    pathA.reset();
    pathA.lineTo(c.dx, c.dy); //移动到c点
    pathA.quadraticBezierTo(e.dx, e.dy, b.dx, b.dy); //从c到b画贝塞尔曲线，控制点为e
    pathA.lineTo(ax, ay); //移动到a点
    pathA.lineTo(k.dx, k.dy); //移动到k点
    pathA.quadraticBezierTo(h.dx, h.dy, j.dx, j.dy); //从k到j画贝塞尔曲线，控制点为h
    pathA.lineTo(size.width, size.height); //移动到右下角
    pathA.lineTo(0, size.height); //移动到左下角
    pathA.close();
    return pathA;
  }

  Path getPathA() {
    if (offset.dx == -1 && offset.dy == -1) {
      return getPathDefault();
    }
    if (f.dx != size.width && f.dy != size.height) {
      return getPathAFromTopRight();
    }
    pathA.reset();
    pathA.lineTo(0, size.height); //移动到左下角
    pathA.lineTo(c.dx, c.dy); //移动到c点
    pathA.quadraticBezierTo(e.dx, e.dy, b.dx, b.dy); //从c到b画贝塞尔曲线，控制点为e
    pathA.lineTo(ax, ay); //移动到a点
    pathA.lineTo(k.dx, k.dy); //移动到k点
    pathA.quadraticBezierTo(h.dx, h.dy, j.dx, j.dy); //从k到j画贝塞尔曲线，控制点为h
    pathA.lineTo(size.width, 0); //移动到右上角
    pathA.close(); //闭合区域
    return pathA;
  }

  Path getPathB() {
    pathB.reset();
    pathB.lineTo(0, size.height); //移动到左下角
    pathB.lineTo(size.width, size.height); //移动到右下角
    pathB.lineTo(size.width, 0); //移动到右上角
    pathB.close(); //闭合区域
    return pathB;
  }

  Path getPathC() {
    pathC.reset();
    pathC.moveTo(i.dx, i.dy); //移动到i点
    pathC.lineTo(d.dx, d.dy); //移动到d点
    pathC.lineTo(b.dx, b.dy); //移动到b点
    pathC.lineTo(ax, ay); //移动到a点
    pathC.lineTo(k.dx, k.dy); //移动到k点
    pathC.close(); //闭合区域
    return pathC;
  }

  Path getPathDefault() {
    pathA.reset();
    pathA.lineTo(0, size.height); //移动到左下角
    pathA.lineTo(size.width, size.height);
    pathA.lineTo(size.width, 0);
    pathA.close();
    return pathA;
  }
}
