import 'package:flutter/material.dart';
import 'package:ui_techniques/features/duolingo_elements/models/point_model.dart';

class ZigZagListPage extends StatefulWidget {
  const ZigZagListPage({super.key});

  @override
  State<ZigZagListPage> createState() => _ZigZagListPageState();
}

class _ZigZagListPageState extends State<ZigZagListPage> {
  @override
  Widget build(BuildContext context) {
    final points = generateZigzagPoints(startX: 0, startY: 10, step: 5, count: 10);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ZigZag List"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: points.length,
        itemBuilder: (context, index) {
          final point = points[index];

          return Align(
            alignment: Alignment(point.x / 10, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '(${point.x.toStringAsFixed(1)}, ${point.y.toStringAsFixed(1)})',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<PointModel> generateZigzagPoints({
    required double startX,
    required double startY,
    required double step,
    required int count,
  }) {
    List<PointModel> points = [];
    double currentX = startX;
    double currentY = startY;
    bool goingLeft = true;

    for (int i = 0; i < count; i++) {
      // Add the main point
      points.add(PointModel(x: currentX, y: currentY));

      // Add the intermediate point
      double intermediateX = currentX + (goingLeft ? -step / 2 : step / 2);
      double intermediateY = currentY - step / 2;
      points.add(PointModel(x: intermediateX, y: intermediateY));

      // Move to the next main point
      currentX += goingLeft ? -step : step;
      currentY -= step;

      // Switch direction
      goingLeft = !goingLeft;
    }

    return points;
  }
}
