import 'dart:math';

import 'package:flutter/material.dart';

class WavePage extends StatefulWidget {
  const WavePage({super.key});

  @override
  State<WavePage> createState() => _WavePageState();
}

class _WavePageState extends State<WavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wave'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12,
            children: [
              Container(
                color: Colors.blue.withAlpha(26),
                height: 300,
                width: double.infinity,
                child: LayoutBuilder(builder: (context, constraints) {
                  return WaveWidget(
                    size: Size(constraints.maxWidth, 200),
                    yOffset: 100,
                    color: Colors.blue,
                  );
                }),
              ),
              Container(
                color: Colors.blue.withAlpha(26),
                height: 300,
                width: double.infinity,
                child: LayoutBuilder(builder: (context, constraints) {
                  return WaveWidget(
                    size: Size(constraints.maxWidth, 200),
                    yOffset: 100,
                    color: Colors.blue,
                  );
                }),
              ),
              Container(
                color: Colors.blue.withAlpha(26),
                height: 200,
                width: double.infinity * 0.02,
                child: LayoutBuilder(builder: (context, constraints) {
                  return WaveWidget(
                    size: Size(constraints.maxWidth, 200),
                    yOffset: 100,
                    color: Colors.blue,
                  );
                }),
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: ClipOval(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return WaveWidget(
                        size: size,
                        yOffset: size.height / 2,
                        color: Colors.blueAccent,
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(constraints.maxWidth, constraints.maxHeight);
                      return WaveWidget(
                        size: size,
                        yOffset: size.height / 2,
                        color: Colors.blueAccent,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveWidget extends StatefulWidget {
  final Size size;
  final double yOffset;
  final Color color;
  const WaveWidget({super.key, required this.size, required this.yOffset, required this.color});

  @override
  State<WaveWidget> createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveWidget> with TickerProviderStateMixin {
  late AnimationController animationController;
  List<Offset> wavePoints = [];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
      // reverseDuration: const Duration(milliseconds: 300),/
    )..addListener(() {
        wavePoints.clear();

        final double waveSpeed = animationController.value * 1080;
        final double fullSphere = animationController.value * 2 * pi;
        final double normalizer = cos(fullSphere);
        const double waveWidth = pi / 270;
        const double waveHeight = 20.0;

        for (int i = 0; i <= widget.size.width.toInt(); ++i) {
          double calc = sin((waveSpeed - i) * waveWidth);
          wavePoints.add(
            Offset(
              i.toDouble(),
              calc * waveHeight * normalizer + widget.yOffset,
            ),
          );
        }
      });

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    wavePoints.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return ClipPath(
          clipper: ClipperWidget(waveList: wavePoints),
          child: Container(
            width: widget.size.width,
            height: widget.size.height,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class ClipperWidget extends CustomClipper<Path> {
  final List<Offset> waveList;

  ClipperWidget({required this.waveList});

  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.addPolygon(waveList, false);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
