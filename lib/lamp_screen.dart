import 'package:flash_lamp/assets.dart';
import 'package:flutter/material.dart';

class LampScreen extends StatefulWidget {
  const LampScreen({Key? key}) : super(key: key);

  @override
  State<LampScreen> createState() => _State();
}

class _State extends State<LampScreen> {
  Offset tapPosition = const Offset(0.0, 150.0);
  Offset anchor = const Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  bool isFlashOn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPosition();
      setState(() {});
    });
  }

  getPosition() {
    RenderBox? box = globalKey.currentContext?.findRenderObject() as RenderBox?;
    anchor = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    anchor = Offset(anchor.dx + 50, anchor.dy + 38);
    tapPosition = Offset(anchor.dx, anchor.dy + 150);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              key: globalKey,
              isFlashOn ? Assets.lampOnImage : Assets.lampOffImage,
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  100, // Adjust the height as needed
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    tapPosition = details.localPosition;
                  });
                },
                onPanEnd: (details) {
                  // open flash or close it
                  setState(() {
                    tapPosition = Offset(anchor.dx, anchor.dy + 150);
                  });
                },
                child: CustomPaint(
                  painter:
                      SpringPainter(newPosition: tapPosition, anchor: anchor),
                  child: Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpringPainter extends CustomPainter {
  final Offset newPosition;
  final Offset anchor;

  const SpringPainter({required this.newPosition, required this.anchor});

  @override
  void paint(Canvas canvas, Size size) {
    var line = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawLine(anchor, newPosition, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
