import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

class ScratchViewModel extends ChangeNotifier {
  final GlobalKey boundaryKey = GlobalKey();

  ui.Image? _initialMask;
  ui.Image? _maskImage;
//   ValueNotifier<List<Offset>> _points = ValueNotifier.value([];

  ValueNotifier<List<Offset>> _points = ValueNotifier<List<Offset>>([]);

  ui.Image? get maskImage => _maskImage;
  ValueNotifier<List<Offset>> get points => _points;

  Future<void> captureOverlay(BuildContext context) async {
    final boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final img = await boundary.toImage(
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    );
    _initialMask = img;
    _maskImage = img;
    notifyListeners();
  }

  void addPoint(Offset globalPosition) {
    final box = boundaryKey.currentContext!.findRenderObject() as RenderBox;
    // _points.add(box.globalToLocal(globalPosition));
    _points.value = List.from(_points.value)..add(box.globalToLocal(globalPosition));
    notifyListeners();
  }

  Future<void> resetScratch(BuildContext context) async {
    _points.value = [];
    _maskImage = _initialMask;
    notifyListeners();
  }

  void clear() {
    // _points.clear();
    _points.value = [];
    notifyListeners();
  }
}
