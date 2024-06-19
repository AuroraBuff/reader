import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reader/model/file.dart';
import 'package:reader/model/painter.dart';

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
  GlobalKey key = GlobalKey();
  Styles style = Styles.styleLowerRight;
  Offset offset = const Offset(-1, -1);
  Size size = const Size(0, 0);
  late Painter painter;
  handlePointerDown(PointerDownEvent details, double width, double height) {
    double x = details.localPosition.dx;
    double y = details.localPosition.dy;
    Styles style2 = Styles.styleLowerRight;
    if (x <= width / 3) {
      //左
      style2 = Styles.styleLeft;
      print('点击了左部');
    } else if (x > width / 3 && y <= height / 3) {
      //上
      style2 = Styles.styleTopRight;
      print('点击了上部');
    } else if (x > width * 2 / 3 && y > height / 3 && y <= height * 2 / 3) {
      //右
      style2 = Styles.styleRight;
      print('点击了右部');
    } else if (x > width / 3 && y > height * 2 / 3) {
      //下
      style2 = Styles.styleLowerRight;
      print("点击了下部");
    } else if (x > width / 3 &&
        x < width * 2 / 3 &&
        y > height / 3 &&
        y < height * 2 / 3) {
      //中
      style2 = Styles.styleMiddle;
      print("点击了中部");
    }

    setState(() {
      offset = details.localPosition;
      size = Size(width, height);
      style = style2;
    });
  }

  handlePointerMove(PointerMoveEvent details) {
    double fx = size.width;
    double fy = size.height;
    switch (style) {
      case Styles.styleTopRight:
        fy = 0;
        break;
      case Styles.styleLowerRight:
        fy = size.height;
        break;
      case Styles.styleLeft:
      case Styles.styleRight:
        double ay = size.height - 1;
        fx = size.width;
        fy = size.width;
        setState(() {
          offset = Offset(details.localPosition.dx, ay);
        });
      default:
        break;
    }
    Offset f = Offset(fx, fy);
    if (painter.calcPointCX(details.localPosition, f) > 0) {
      setState(() {
        offset = details.localPosition;
      });
    } else {
      setState(() {
        offset = painter.calcPointAByTouchPoint(offset, f);
      });
    }
  }

  handlePointerUp(PointerUpEvent details) {
    setState(() {
      offset = const Offset(-1, -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Listener(
        onPointerDown: (event) => handlePointerDown(
          event,
          constraints.maxWidth,
          constraints.maxHeight,
        ),
        onPointerMove: handlePointerMove,
        onPointerUp: handlePointerUp,
        child: Container(
          color: Colors.white,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: CustomPaint(
            painter: MyCustomPainter(painter = Painter(offset,
                Size(constraints.maxWidth, constraints.maxHeight), style)),
          ),
        ),
      );
    });
  }
}

class MyCustomPainter extends CustomPainter {
  Painter painter;
  MyCustomPainter(this.painter);

  TextPainter getTextSpan(String text) {
    TextSpan span = TextSpan(
      text: text,
      spellOut: true,
      style: const TextStyle(
        fontSize: 20.0,
        fontFamily: 'serif',
        color: Colors.white,
      ),
    );
    var dt = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    dt.layout();
    return dt;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var text = getTextSpan('hello world');

    // var as = getTextSpan('a');
    // var bs = getTextSpan('b');
    // var cs = getTextSpan('c');
    // var ds = getTextSpan('d');
    // var es = getTextSpan('e');
    // var fs = getTextSpan('f');
    // var gs = getTextSpan('g');
    // var hs = getTextSpan('h');
    // var iss = getTextSpan('i');
    // var js = getTextSpan('j');
    // var ks = getTextSpan('k');

    // as.paint(canvas, painter.a);
    // bs.paint(canvas, painter.b);
    // cs.paint(canvas, painter.c);
    // ds.paint(canvas, painter.d);
    // es.paint(canvas, painter.e);
    // fs.paint(canvas, painter.f);
    // gs.paint(canvas, painter.g);
    // hs.paint(canvas, painter.h);
    // iss.paint(canvas, painter.i);
    // js.paint(canvas, painter.j);
    // ks.paint(canvas, painter.k);

    if (painter.a.dx != -1 && painter.a.dy != -1) {
      canvas.drawPath(painter.getPathB(), painter.pathBPaint);
      canvas.drawPath(painter.getPathC(), painter.pathCPaint);
    }

    canvas.drawPath(painter.getPathA(), painter.pathAPaint);
    text.paint(canvas, const Offset(0, 0));

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
