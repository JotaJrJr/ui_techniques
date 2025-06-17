// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'liquid_glass_view_model.dart';

// class LiquidGlassPainter extends CustomPainter {
//   final LiquidGlassViewModel viewModel;
//   final FragmentShader? shader;

//   LiquidGlassPainter(this.viewModel, {this.shader});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final unionPath = _buildUnionPath();

//     // Apply blur to the background
//     final blurPaint = Paint()
//       ..color = Color.fromRGBO(0, 0, 0, 0.2) // Fixed color creation
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, viewModel.blurSigma);
//     canvas.drawPath(unionPath, blurPaint);

//     // Draw glass surface
//     if (shader != null) {
//       // Shader is already configured with uniforms by the ViewModel
//       canvas.drawPath(unionPath, Paint()..shader = shader);
//     } else {
//       // Fallback to gradient if shader not available
//       final gradient = RadialGradient(
//         radius: 0.7,
//         colors: [
//           _colorWithOpacity(Colors.white, 0.4 * viewModel.lightIntensity),
//           _colorWithOpacity(Colors.white, 0.1 * viewModel.lightIntensity),
//         ],
//       );
//       canvas.drawPath(
//         unionPath,
//         Paint()..shader = gradient.createShader(unionPath.getBounds()),
//       );
//     }

//     // Draw corners with distortion
//     _drawDistortedCorners(canvas);
//   }

//   // Helper function to create colors with proper opacity
//   Color _colorWithOpacity(Color color, double opacity) {
//     return color.withOpacity(opacity.clamp(0.0, 1.0));
//   }

//   Path _buildUnionPath() {
//     Path unionPath = Path();
//     for (var box in viewModel.boxes) {
//       final rect = Rect.fromLTWH(
//         box.position.dx,
//         box.position.dy,
//         box.width,
//         box.height,
//       );

//       final path = viewModel.cornerRadius > 0

//             ?

//         //   ? Path()..addRRect(RRect.fromRectAndRadius(
//         //       rect,
//         //       Radius.circular(viewModel.cornerRadius),
//         //     ))
//         //   : Path()..addRect(rect);

//       unionPath = Path.combine(PathOperation.union, unionPath, path);
//     }
//     return unionPath;
//   }

//   void _drawDistortedCorners(Canvas canvas) {
//     final distortion = viewModel.thickness * viewModel.cornerDistortion * 1.5;

//     for (var box in viewModel.boxes) {
//       final rect = Rect.fromLTWH(
//         box.position.dx,
//         box.position.dy,
//         box.width,
//         box.height,
//       );

//       final corners = [
//         rect.topLeft,
//         rect.topRight,
//         rect.bottomRight,
//         rect.bottomLeft,
//       ];

//       for (final corner in corners) {
//         final paint = Paint()
//           ..color = _colorWithOpacity(Colors.white, 0.3)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, distortion * 2);

//         canvas.drawCircle(
//           corner,
//           viewModel.cornerRadius + distortion,
//           paint,
//         );
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant LiquidGlassPainter oldDelegate) => true;
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'liquid_glass_view_model.dart';

class LiquidGlassPainter extends CustomPainter {
  final LiquidGlassViewModel viewModel;
  final FragmentShader? shader;

  LiquidGlassPainter(this.viewModel, {this.shader});

  @override
  void paint(Canvas canvas, Size size) {
    final unionPath = _buildUnionPath();

    // Apply blur to the background
    final blurPaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, viewModel.blurSigma);
    canvas.drawPath(unionPath, blurPaint);

    // Draw glass surface
    if (shader != null) {
      canvas.drawPath(unionPath, Paint()..shader = shader);
    } else {
      final gradient = RadialGradient(
        radius: 0.7,
        colors: [
          _colorWithOpacity(Colors.white, 0.4 * viewModel.lightIntensity),
          _colorWithOpacity(Colors.white, 0.1 * viewModel.lightIntensity),
        ],
      );
      canvas.drawPath(
        unionPath,
        Paint()..shader = gradient.createShader(unionPath.getBounds()),
      );
    }

    // Draw corners with distortion
    _drawDistortedCorners(canvas);
  }

  Color _colorWithOpacity(Color color, double opacity) {
    return color.withOpacity(opacity.clamp(0.0, 1.0));
  }

  Path _buildUnionPath() {
    Path unionPath = Path();
    for (var box in viewModel.boxes) {
      final rect = Rect.fromLTWH(
        box.position.dx,
        box.position.dy,
        box.width,
        box.height,
      );

      Path path = Path();

      if (viewModel.cornerRadius > 0) {
        path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(viewModel.cornerRadius)));
      } else {
        path.addRect(rect);
      }

      //   final path = viewModel.cornerRadius > 0
      //       ? Path()
      //           ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(viewModel.cornerRadius)))
      //       : Path()
      //           ..addRect(rect);

      unionPath = Path.combine(PathOperation.union, unionPath, path);
    }
    return unionPath;
  }

  void _drawDistortedCorners(Canvas canvas) {
    final distortion = viewModel.thickness * viewModel.cornerDistortion * 1.5;

    for (var box in viewModel.boxes) {
      final rect = Rect.fromLTWH(
        box.position.dx,
        box.position.dy,
        box.width,
        box.height,
      );

      final corners = [
        rect.topLeft,
        rect.topRight,
        rect.bottomRight,
        rect.bottomLeft,
      ];

      for (final corner in corners) {
        final paint = Paint()
          ..color = _colorWithOpacity(Colors.white, 0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, distortion * 2);

        canvas.drawCircle(
          corner,
          viewModel.cornerRadius + distortion,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant LiquidGlassPainter oldDelegate) => true;
}
