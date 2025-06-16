import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedScrollTextViewModel extends ChangeNotifier {
  String text = 'Texto pra Teste';
  List<GlobalKey> textKeys = [];
  int? selectedIndex;
  bool isDragging = false;

  final String textTwo = 'Texto pra Teste...';
  int? selectedIndexTwo;
  int _currentIndex = 0;
  late Timer _timer;

  AnimatedScrollTextViewModel() {
    textKeys.addAll(List.generate(text.length, (_) => GlobalKey()));
    _startAnimation();
  }

  void _updateSelectedIndex(Offset position) {
    for (int i = 0; i < textKeys.length; i++) {
      final key = textKeys[i];
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;
      final boxPosition = renderBox.localToGlobal(Offset.zero);
      final boxSize = renderBox.size;

      if (position.dx >= boxPosition.dx && position.dx <= boxPosition.dx + boxSize.width) {
        selectedIndex = i;
        return;
      }
    }
  }

  void startDrag(Offset position) {
    isDragging = true;
    _updateSelectedIndex(position);
    notifyListeners();
  }

  void stopDrag() {
    isDragging = false;
    selectedIndex = null;
    notifyListeners();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      selectedIndexTwo = _currentIndex;
      notifyListeners();

      _currentIndex++;
      if (_currentIndex >= textTwo.length) {
        // _timer.cancel();
        _currentIndex = 0;
      }
    });
  }
}
