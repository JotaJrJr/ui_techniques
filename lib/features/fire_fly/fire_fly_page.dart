import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FireFlyPage extends StatefulWidget {
  const FireFlyPage({super.key});

  @override
  State<FireFlyPage> createState() => _FireFlyPageState();
}

enum ColorMode { gold, random }

enum BackgroundMode { black, white }

enum AnimationMode { move, fade }

class _FireFlyPageState extends State<FireFlyPage> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Random _random = Random();

  List<Offset> _positions = [];
  List<Offset> _velocities = [];
  List<double> _phases = [];
  List<double> _periods = [];
  List<double> _opacities = [];

  ColorMode _colorMode = ColorMode.gold;
  BackgroundMode _bgMode = BackgroundMode.black;
  AnimationMode _animMode = AnimationMode.move;
  int _count = 30;

  @override
  void initState() {
    super.initState();
    _initParticles();
    _ticker = createTicker(_tick)..start();
  }

  void _initParticles() {
    _positions = List.generate(_count, (_) => Offset(_random.nextDouble(), _random.nextDouble()));
    _velocities = List.generate(_count, (_) {
      final speed = 0.0005 + _random.nextDouble() * 0.001;
      final angle = _random.nextDouble() * pi * 2;
      return Offset(cos(angle) * speed, sin(angle) * speed);
    });
    _phases = List.generate(_count, (_) => _random.nextDouble());
    _periods = List.generate(_count, (_) => 2 + _random.nextDouble() * 2);
    _opacities = List.filled(_count, 1.0);
  }

  void _tick(Duration elapsed) {
    final t = elapsed.inMilliseconds / 1000;
    setState(() {
      if (_animMode == AnimationMode.move) {
        for (var i = 0; i < _count; i++) {
          var p = _positions[i] + _velocities[i];
          if (p.dx < 0 || p.dx > 1) _velocities[i] = Offset(-_velocities[i].dx, _velocities[i].dy);
          if (p.dy < 0 || p.dy > 1) _velocities[i] = Offset(_velocities[i].dx, -_velocities[i].dy);
          _positions[i] = Offset(p.dx.clamp(0, 1), p.dy.clamp(0, 1));
          _opacities[i] = 1.0;
        }
      } else {
        for (var i = 0; i < _count; i++) {
          final phase = _phases[i];
          final period = _periods[i];
          final value = 0.5 + 0.5 * sin(2 * pi * (t + phase) / period);

          /// isso aqui foi GPT
          /// computando uma onda de seno seria
          /// value = 0.5 + 0.5 * seno de (2 * pi (t + phase) / period)
          /// que oscila entre 0 e 1
          _opacities[i] = 0.3 + 0.7 * value;
        }
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Color _getColor() {
    if (_colorMode == ColorMode.gold) {
      return HSVColor.fromAHSV(
        1,
        50 + _random.nextDouble() * 20,
        0.8 + _random.nextDouble() * 0.2,
        0.8 + _random.nextDouble() * 0.2,
      ).toColor();
    } else {
      return Color.fromARGB(
        255,
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _bgMode == BackgroundMode.black ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text('Firefly')),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, bc) => CustomPaint(
                size: bc.biggest,
                painter: _FireflyPainter(
                  positions: _positions,
                  getColor: _getColor,
                  opacities: _opacities,
                ),
              ),
            ),
          ),
          ColoredBox(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Count:'),
                      Expanded(
                        child: Slider(
                          value: _count.toDouble(),
                          min: 5,
                          max: 100,
                          divisions: 95,
                          label: '$_count',
                          onChanged: (v) => setState(() {
                            _count = v.toInt();
                            _initParticles();
                          }),
                        ),
                      ),
                    ],
                  ),
                  ToggleButtons(
                    isSelected: [
                      _colorMode == ColorMode.gold,
                      _colorMode == ColorMode.random,
                    ],
                    onPressed: (i) => setState(() {
                      _colorMode = ColorMode.values[i];
                    }),
                    children: const [Text('Gold'), Text('Random')],
                  ),
                  const SizedBox(height: 8),
                  ToggleButtons(
                    isSelected: [
                      _bgMode == BackgroundMode.black,
                      _bgMode == BackgroundMode.white,
                    ],
                    onPressed: (i) => setState(() {
                      _bgMode = BackgroundMode.values[i];
                    }),
                    children: const [Text('Black BG'), Text('White BG')],
                  ),
                  const SizedBox(height: 8),
                  ToggleButtons(
                    isSelected: [
                      _animMode == AnimationMode.move,
                      _animMode == AnimationMode.fade,
                    ],
                    onPressed: (i) => setState(() {
                      _animMode = AnimationMode.values[i];
                    }),
                    children: const [Text('Move'), Text('Fade')],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FireflyPainter extends CustomPainter {
  final List<Offset> positions;
  final List<double> opacities;
  final Color Function() getColor;

  _FireflyPainter({
    required this.positions,
    required this.getColor,
    required this.opacities,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < positions.length; i++) {
      paint.color = getColor().withOpacity(opacities[i]);
      final dx = positions[i].dx * size.width;
      final dy = positions[i].dy * size.height;
      canvas.drawCircle(Offset(dx, dy), 4, paint);
      canvas.drawCircle(
        Offset(dx, dy),
        10,
        paint..color = paint.color.withOpacity(0.1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FireflyPainter old) => true;
}
