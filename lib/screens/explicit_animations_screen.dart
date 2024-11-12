import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() => _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 1),
  )..addListener(() {
      _value.value = _controller.value;
    });

  late final Animation<Decoration> _decoration = DecorationTween(
      begin: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10),
      ),
      end: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(100),
      )).animate(_curve);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 2.0,
  ).animate(_curve);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.1,
  ).animate(_curve);

  late final Animation<Offset> _offset = Tween(
    begin: Offset.zero,
    end: Offset(0.0, -0.5),
  ).animate(_controller);

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceIn,
  );

  void _play() {
    _controller.forward();
  }

  void _pause() {
    _controller.stop();
  }

  void _rewind() {
    _controller.reverse();
  }

  bool _looping = false;

  void _toggleLooping() {
    if (_looping) {
      _controller.stop();
    } else {
      _controller.repeat(reverse: true);
    }

    setState(() {
      _looping = !_looping;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final ValueNotifier _value = ValueNotifier(0.0);
  void _onChanged(double value) {
    _value.value = value;
    _controller.animateTo(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offset,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: SizedBox(
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: Text("Play")),
                ElevatedButton(onPressed: _pause, child: Text("Pause")),
                ElevatedButton(onPressed: _rewind, child: Text("Rewind")),
                ElevatedButton(onPressed: _toggleLooping, child: Text(_looping? "Stop" : "Loop")),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: _value,
              builder: (context, value, child) => Slider(
                value: _value.value,
                onChanged: _onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
