import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 1500,
    ),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  late final Tween<double> _buttonOpacity = Tween(
    begin: 0.0,
    end: 1.0,
  );

  late final dropzone = size.width + 100;

  void _reset() {
    _position.value = 0;
    setState(() {
      index = index == 5 ? 1 : index + 1;
    });
  }

  void _transformRight() {
    _position.animateTo(dropzone).whenComplete(_reset);
  }

  void _transformLeft() {
    _position.animateTo(dropzone * -1).whenComplete(_reset);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width * 0.7;
    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position.animateTo(dropzone * -1).whenComplete(_reset);
      } else {
        _position.animateTo(dropzone * 1).whenComplete(_reset);
      }
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
          animation: _position,
          builder: (context, child) {
            final angle = _rotation.transform((_position.value / size.width + 1) / 2);
            final scale = _scale.transform((_position.value.abs() / size.width));
            final greenButtonOpacity = _buttonOpacity.transform((_position.value /size.width).clamp(0, 1));
            final redButtonOpacity = _buttonOpacity.transform((_position.value / size.width * -1).clamp(0, 1));
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 100,
                  child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: Card(
                      index: index == 5 ? 1 : index + 1,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Transform.translate(
                      offset: Offset(_position.value, 0),
                      child: Transform.rotate(
                        angle: angle * pi / 180,
                        child: Card(index: index),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: Row(
                    children: [
                      Button(
                        color: Colors.red.shade300,
                        opacity: redButtonOpacity,
                        icon: Icons.close,
                        onTap: _transformLeft,
                      ),
                      Button(
                        color: Colors.green.shade300,
                        opacity: greenButtonOpacity,
                        icon: Icons.check,
                        onTap: _transformRight,
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

class Button extends StatelessWidget {
  final Color color;
  final double opacity;
  final IconData icon;
  final VoidCallback onTap;

  const Button({
    super.key,
    required this.color,
    required this.opacity,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(opacity),
          ),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.black,
          )),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(10),
      child: Container(
          width: size.width * 0.8,
          height: size.height * 0.5,
          child: Image.asset(
            'assets/covers/$index.jpg',
            fit: BoxFit.cover,
          )),
    );
  }
}
