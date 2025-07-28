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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
