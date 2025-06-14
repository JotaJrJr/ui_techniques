import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_techniques/features/animated_widgets/animated_widgets_view_model.dart';

class AnimatedWidgets extends StatefulWidget {
  final AnimatedWidgetsViewModel viewModel;
  const AnimatedWidgets({super.key, required this.viewModel});

  @override
  State<AnimatedWidgets> createState() => _AnimatedWidgetsState();
}

class _AnimatedWidgetsState extends State<AnimatedWidgets> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController textScaleController;

  late Animation<double> progressAnimation;
  late Animation<double> textScale;

  final ValueNotifier<double> progressValue = ValueNotifier(0.0);
  final ValueNotifier<int> counter = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 300),
    );

    textScaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(milliseconds: 300),
    );

    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        progressValue.value = progressAnimation.value;
        if (controller.isCompleted) {
          controller.reset();
          textScaleController.reset();
          counter.value++;
        }
      });

    textScale = Tween<double>(begin: 1.0, end: 1.6).animate(CurvedAnimation(
      parent: textScaleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    textScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animated Widgets")),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 12.0,
              children: [
                GestureDetector(
                  onTapDown: (_) {
                    controller.forward();
                    textScaleController.forward();
                  },
                  onTapUp: (_) {
                    if (controller.status == AnimationStatus.forward) {
                      controller.reverse();
                      textScaleController.reverse();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 135,
                        width: 135,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black.withAlpha(26)),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: progressValue,
                        builder: (_, value, __) {
                          return SizedBox(
                            height: 135,
                            width: 135,
                            child: CircularProgressIndicator(
                              value: value,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: AnimatedBuilder(
                          animation: textScale,
                          builder: (_, __) => ValueListenableBuilder<int>(
                            valueListenable: counter,
                            builder: (_, count, __) => CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Transform.scale(
                                scale: textScale.value,
                                child: Text(
                                  count.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
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
