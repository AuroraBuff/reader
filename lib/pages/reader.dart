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
  Styles style = Styles.styleLowerRight;
  Offset offset = const Offset(-1, -1);

  handlePointerDown(PointerDownEvent details, double width, double height) {
    print('handlePointerDown: height:$width, height:$height');
    if (details.localPosition.dy < (height / 2)) {
      setState(() {
        style = Styles.styleTopRight;
      });
      //从上半部分翻页
      // bookPageView.setTouchPoint(event.getX(),event.getY(),bookPageView.STYLE_TOP_RIGHT);
    } else {
      //从下半部分翻页
      // bookPageView.setTouchPoint(event.getX(),event.getY(),bookPageView.STYLE_LOWER_RIGHT);
      setState(() {
        style = Styles.styleLowerRight;
      });
    }
  }

  handlePointerMove(PointerMoveEvent details) {
    setState(() {
      offset = details.localPosition;
    });
  }

  handlePointerUp(PointerUpEvent details) {
    print('handlePointerUp: ${details.localPosition}');
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
            painter: MyCustomPainter(offset, style: style),
          ),
        ),
      );
    });
  }
}

class MyCustomPainter extends CustomPainter {
  Offset t;
  Styles style;
  double num = 0.0;
  MyCustomPainter(this.t, {this.style = Styles.styleLowerRight});

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

  @override
  void paint(Canvas canvas, Size size) {
    Painter painter = Painter(t, size, style);
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

    as.paint(canvas, painter.offset);
    bs.paint(canvas, painter.b);
    cs.paint(canvas, painter.c);
    ds.paint(canvas, painter.d);
    es.paint(canvas, painter.e);
    fs.paint(canvas, painter.f);
    gs.paint(canvas, painter.g);
    hs.paint(canvas, painter.h);
    iss.paint(canvas, painter.i);
    js.paint(canvas, painter.j);
    ks.paint(canvas, painter.k);

    canvas.drawPath(painter.pathB, painter.pathBPaint);
    canvas.drawPath(painter.pathC, painter.pathCPaint);
    canvas.drawPath(painter.getPathA(), painter.pathAPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
