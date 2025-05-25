import 'dart:math';

import 'package:flutter/material.dart';

import '../models/prize_model.dart';
import '../widgets/wheel_painter_widget.dart';

class SpinningWheel extends StatefulWidget {
  final List<Prize> prizes;
  final double size;
  final Duration spinDuration;

  const SpinningWheel({
    Key? key,
    required this.prizes,
    required this.size,
    required this.spinDuration,
  }) : super(key: key);

  @override
  _SpinningWheelState createState() => _SpinningWheelState();
}

class _SpinningWheelState extends State<SpinningWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _rotationAngle = 0.0;
  Prize? _winningPrize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.spinDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    );

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _calculateWinningPrize();
      }
    });
  }

  // void _calculateWinningPrize() {
  //   final prizeAngle = 360 / widget.prizes.length; // Angle per segment
  //   final normalizedAngle = _rotationAngle % 360; // Normalize to 0-360 degrees

  //   // Calculate the winning index based on the arrow's position (0 degrees)
  //   final winningIndex = (normalizedAngle ~/ prizeAngle) % widget.prizes.length;

  //   setState(() {
  //     _winningPrize = widget.prizes[winningIndex];
  //   });
  //   print('Winning Prize: ${_winningPrize!.name}');
  // }

  void _calculateWinningPrize() {
    final prizeAngle = 360 / widget.prizes.length;
    final normalizedAngle = _rotationAngle % 360;

    final winningIndex = (widget.prizes.length - (normalizedAngle / prizeAngle).floor()) % widget.prizes.length;

    setState(() {
      _winningPrize = widget.prizes[winningIndex];
    });
    print('Winning Prize: ${_winningPrize!.name}');
  }

  void spin() {
    final random = Random();
    final rotations = 5 + random.nextInt(5);
    final prizeAngle = 360 / widget.prizes.length;
    final winningPrizeIndex = random.nextInt(widget.prizes.length);
    final endAngle = rotations * 360 + (winningPrizeIndex * prizeAngle);

    setState(() {
      _rotationAngle = endAngle;
      _winningPrize = null;
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake-Like List'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // const Positioned(
              //   top: -20,
              //   child: Icon(
              //     Icons.arrow_drop_down,
              //     size: 50,
              //     color: Colors.black,
              //   ),
              // ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: (_rotationAngle * _animation.value) * (pi / 180),
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: WheelPainter(widget.prizes),
                    ),
                  );
                },
              ),
              const Positioned(
                top: -20,
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              // Container(
              //   height: 50,
              //   width: 50,
              //   color: Colors.red,
              // ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: spin,
            child: const Text('Spin'),
          ),
          const SizedBox(height: 20),
          if (_winningPrize != null)
            Text(
              'Winner: ${_winningPrize!.name}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _winningPrize!.color,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
