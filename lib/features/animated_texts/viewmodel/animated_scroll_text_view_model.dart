import 'package:flutter/material.dart';

class AnimatedScrollTextViewModel extends ChangeNotifier {
  String text = 'Happy Birthday!';
  List<GlobalKey> textKeys = [];
  int? selectedIndex;
  bool isDragging = false;

  AnimatedScrollTextViewModel() {
    textKeys.addAll(List.generate(text.length, (_) => GlobalKey()));
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
}
