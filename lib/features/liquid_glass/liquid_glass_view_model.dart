import 'package:flutter/material.dart';

/// Simple model for a draggable glass box (rectangle).
class GlassBox {
  Offset position; // Top-left corner of the box
  double width;
  double height;
  GlassBox({required this.position, required this.width, required this.height});
}

/// ViewModel holding the state of the glass boxes and user settings.
/// Uses ChangeNotifier to allow listening (if needed).
class LiquidGlassViewModel extends ChangeNotifier {
  List<GlassBox> boxes = [];
  double blurSigma = 10.0; // How much to blur background:contentReference[oaicite:9]{index=9}
  double thickness = 0.3; // Glass border thickness (refract strength):contentReference[oaicite:10]{index=10}
  double lightIntensity = 1.0; // Brightness of the internal highlight:contentReference[oaicite:11]{index=11}
  double chromaticShift = 2.0; // Chromatic aberration offset
  double cornerRadius = 20.0; // Corner roundness of the boxes
  double cornerDistortion = 1.5;

  LiquidGlassViewModel() {
    // Initialize with two sample boxes at different positions
    boxes = [
      GlassBox(position: const Offset(100, 150), width: 150, height: 150),
      GlassBox(position: const Offset(250, 300), width: 150, height: 150),
    ];
  }

  // Update methods for settings (called by sliders)
  void updateBlur(double value) {
    blurSigma = value;
    notifyListeners();
  }

  void updateCornerDistortion(double value) {
    cornerDistortion = value;
    notifyListeners();
  }

  void updateThickness(double value) {
    thickness = value;
    notifyListeners();
  }

  void updateLightIntensity(double value) {
    lightIntensity = value;
    notifyListeners();
  }

  void updateChromaticShift(double value) {
    chromaticShift = value;
    notifyListeners();
  }

  void updateCornerRadius(double value) {
    cornerRadius = value;
    notifyListeners();
  }

  /// Update the position of a specific box by index.
  void updateBoxPosition(int index, Offset newPosition) {
    if (index < 0 || index >= boxes.length) return;
    boxes[index].position = newPosition;
    notifyListeners();
  }

  /// Check if a given point (e.g. from a tap) lies inside any box.
  /// Returns the index of the box or null.
  int? boxAtPoint(Offset point) {
    // Check topmost box first
    for (int i = boxes.length - 1; i >= 0; i--) {
      final box = boxes[i];
      final rect = Rect.fromLTWH(box.position.dx, box.position.dy, box.width, box.height);
      if (rect.contains(point)) {
        return i;
      }
    }
    return null;
  }
}
