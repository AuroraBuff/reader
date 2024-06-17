import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reader/model/file.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  void handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> extraString =
        GoRouterState.of(context).extra! as Map<String, dynamic>;

    LocalFile localFile = LocalFile(extraString['path'], extraString['name']);

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => handleBack(context)),
          title: Text(localFile.name),
        ),
        body: const PopScope(
          canPop: false,
          child: SafeArea(
            child: FlipPageAnimation(),
          ),
        ));
  }
}

class FlipPageAnimation extends StatefulWidget {
  const FlipPageAnimation({super.key});

  @override
  _FlipPageAnimationState createState() => _FlipPageAnimationState();
}

class _FlipPageAnimationState extends State<FlipPageAnimation>
    with SingleTickerProviderStateMixin {
  Offset offset = const Offset(200, 200);
  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        // 获取触摸点的位置
        Offset position = details.localPosition;
        double x = position.dx;
        double y = position.dy;
        // 计算控制点的位置
        setState(() {
          offset = Offset(x, y);
        });
      },
      child: Container(
        color: Colors.white,
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: MyCustomPainter(offset),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  Offset t;
  MyCustomPainter(this.t);

  /// 计算两线段相交点坐标
  /// @param lineOne_My_pointOne
  /// @param lineOne_My_pointTwo
  /// @param lineTwo_My_pointOne
  /// @param lineTwo_My_pointTwo
  /// @return 返回该点
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

  TextPainter getTextSpan(String text) {
    TextSpan span = TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 10.0,
        fontFamily: 'serif',
        color: Colors.black,
      ),
    );
    var dt = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    dt.layout();
    return dt;
  }

  /// 更新点坐标
  /// @param point

  @override
  void paint(Canvas canvas, Size size) {
    Paint pathAPaint = Paint()
      ..color = Colors.green // 降低绿色路径的不透明度
      ..isAntiAlias = true;

    Paint pathBPaint = Paint()
      ..color = Colors.red
      ..isAntiAlias = true;

    Paint pathCPaint = Paint()
      ..color = Colors.blue
      ..isAntiAlias = true;

    // 计算控制点的位置
    double ax = t.dx;
    double ay = t.dy;
    Offset a = Offset(ax, ay);
    double fx = size.width;
    double fy = size.height;
    Offset f = Offset(fx, fy); // 边缘角点
    double gx = (t.dx + size.width) / 2;
    double gy = (t.dy + size.height) / 2;
    Offset g = Offset(gx, gy);
    double ex = gx - (fy - gy) * (fy - gy) / (fx - gx);
    double ey = fy;
    Offset e = Offset(ex, ey);
    double hx = fx;
    double hy = gy - (fx - gx) * (fx - gx) / (fy - gy);
    Offset h = Offset(hx, hy);
    double cx = ex - (fx - ex) / 2;
    double cy = fy;
    Offset c = Offset(cx, cy);
    double jx = fx;
    double jy = hy - (fy - hy) / 2;
    Offset j = Offset(jx, jy);

    Offset b = getCrossPoint(
        Offset(ax, ay), Offset(ex, ey), Offset(cx, cy), Offset(jx, jy));
    double bx = b.dx;
    double by = b.dy;
    Offset k = getCrossPoint(
        Offset(ax, ay), Offset(hx, hy), Offset(cx, cy), Offset(jx, jy));
    double kx = k.dx;
    double ky = k.dy;

    double dx = (cx + 2 * ex + bx) / 4;
    double dy = (2 * ey + cy + by) / 4;
    Offset d = Offset(dx, dy);
    double ix = (jx + 2 * hx + kx) / 4;
    double iy = (2 * hy + jy + ky) / 4;
    Offset i = Offset(ix, iy);

    // 创建一个路径
    Path pathA = Path();
    Path pathB = Path();
    Path pathC = Path();

    // // 在画布上绘制路径
    // canvas.drawPath(path, paint);
    var as = getTextSpan('a');
    var bs = getTextSpan('b');
    var cs = getTextSpan('c');
    var ds = getTextSpan('d');
    var es = getTextSpan('e');
    var fs = getTextSpan('f');
    var gs = getTextSpan('g');
    var hs = getTextSpan('h');
    var iss = getTextSpan('i');
    var js = getTextSpan('j');
    var ks = getTextSpan('k');

    as.paint(canvas, a);
    bs.paint(canvas, b);
    cs.paint(canvas, c);
    ds.paint(canvas, d);
    es.paint(canvas, e);
    fs.paint(canvas, f);
    gs.paint(canvas, g);
    hs.paint(canvas, h);
    iss.paint(canvas, i);
    js.paint(canvas, j);
    ks.paint(canvas, k);

    pathA.reset();
    pathA.lineTo(0, size.height); //移动到左下角
    pathA.lineTo(c.dx, c.dy); //移动到c点
    pathA.quadraticBezierTo(e.dx, e.dy, b.dx, b.dy); //从c到b画贝塞尔曲线，控制点为e
    pathA.lineTo(a.dx, a.dy); //移动到a点
    pathA.lineTo(k.dx, k.dy); //移动到k点
    pathA.quadraticBezierTo(h.dx, h.dy, j.dx, j.dy); //从k到j画贝塞尔曲线，控制点为h
    pathA.lineTo(size.width, 0); //移动到右上角
    pathA.close(); //闭合区域

    pathB.reset();
    pathB.lineTo(0, size.height); //移动到左下角
    pathB.lineTo(size.width, size.height); //移动到右下角
    pathB.lineTo(size.width, 0); //移动到右上角
    pathB.close(); //闭合区域

    pathC.reset();
    pathC.moveTo(i.dx, i.dy); //移动到i点
    pathC.lineTo(d.dx, d.dy); //移动到d点
    pathC.lineTo(b.dx, b.dy); //移动到b点
    pathC.lineTo(a.dx, a.dy); //移动到a点
    pathC.lineTo(k.dx, k.dy); //移动到k点
    pathC.close(); //闭合区域

    canvas.drawPath(pathB, pathBPaint);
    canvas.drawPath(pathC, pathCPaint);
    canvas.drawPath(pathA, pathAPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
