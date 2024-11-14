import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 2,
    ),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  late Animation<double> _progress = Tween(
    begin: 0.005,
    end: 1.5,

  ).animate(_curve);

  void _animatedValues() {
    final newBegin = _progress.value;
    final random = Random();
    final newEnd = random.nextDouble() * 2.0;
    final newTween = Tween(
      begin: newBegin,
      end: newEnd,
    ).animate(_curve);
    setState(() {
      _progress = newTween;
    });

    _animationController.forward(from: 0.0);
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Apple Watch'),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        )
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: _progress,
            builder: (context, child) {
              return CustomPaint(
                painter: AppleWatchPainter(
                  progress: _progress.value,
                ),
                size: const Size(350, 350),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: _animatedValues,
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double progress;

  AppleWatchPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final redCircleRadius = (size.width / 2) * 0.9;
    final greenCircleRadius = (size.width / 2) * 0.72;
    final blueCircleRadius = (size.width / 2) * 0.54;
    const startingAngle = -0.5 * pi;

    // draw red
    final redCirclePaint = Paint()
      ..color = Colors.red.shade300.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawCircle(center, redCircleRadius, redCirclePaint);
    // draw green
    final greenCirclePaint = Paint()
      ..color = Colors.green.shade300.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawCircle(center, greenCircleRadius, greenCirclePaint);
    // draw blue
    final blueCirclePaint = Paint()
      ..color = Colors.blue.shade300.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawCircle(center, blueCircleRadius, blueCirclePaint);

    // red arc
    final redArcRect = Rect.fromCircle(center: center, radius: redCircleRadius);
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(redArcRect, startingAngle, progress * pi, false, redArcPaint);

    // green arc
    final greenArcRect = Rect.fromCircle(center: center, radius: greenCircleRadius);
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(greenArcRect, startingAngle, progress * pi, false, greenArcPaint);

    // blue arc
    final blueArcRect = Rect.fromCircle(center: center, radius: blueCircleRadius);
    final blueArcPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(blueArcRect, startingAngle, progress * pi, false, blueArcPaint);
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
