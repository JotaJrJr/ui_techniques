import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

class ScratchViewModel extends ChangeNotifier {
  final GlobalKey boundaryKey = GlobalKey();
  ui.Image? _maskImage;
  List<Offset> _points = [];

  ui.Image? get maskImage => _maskImage;
  List<Offset> get points => _points;

  Future<void> captureOverlay(BuildContext context) async {
    final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final img = await boundary.toImage(
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    );
    _maskImage = img;
    notifyListeners();
  }

  void addPoint(Offset globalPosition) {
    final box = boundaryKey.currentContext!.findRenderObject() as RenderBox;
    _points.add(box.globalToLocal(globalPosition));
    notifyListeners();
  }

  void clear() {
    _points.clear();
    notifyListeners();
  }
}
