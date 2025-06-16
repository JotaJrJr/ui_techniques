import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_techniques/features/liquid_glass/liquid_glass_view_model.dart';

class LiquidGlassPage extends StatefulWidget {
  const LiquidGlassPage({super.key});

  @override
  State<LiquidGlassPage> createState() => _LiquidGlassPageState();
}

class _LiquidGlassPageState extends State<LiquidGlassPage> {
  late LiquidGlassViewModel viewModel;

  int? draggingIndex;
  Offset dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    viewModel = LiquidGlassViewModel();
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildSettingsSheet(),
    );
  }

  Widget _buildSettingsSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Liquid Glass Settings',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          _buildSlider(
            label: 'Blur',
            value: viewModel.blurSigma,
            min: 0,
            max: 30,
            onChanged: (v) => setState(() => viewModel.updateBlur(v)),
          ),
          _buildSlider(
            label: 'Thickness',
            value: viewModel.thickness,
            min: 0.1,
            max: 10,
            onChanged: (v) => setState(() => viewModel.updateThickness(v)),
          ),
          _buildSlider(
            label: 'Light Intensity',
            value: viewModel.lightIntensity,
            min: 0,
            max: 2,
            onChanged: (v) => setState(() => viewModel.updateLightIntensity(v)),
          ),
          _buildSlider(
            label: 'Chromatic Shift',
            value: viewModel.chromaticShift,
            min: 0,
            max: 10,
            onChanged: (v) => setState(() => viewModel.updateChromaticShift(v)),
          ),
          _buildSlider(
            label: 'Corner Radius',
            value: viewModel.cornerRadius,
            min: 0,
            max: 100,
            onChanged: (v) => setState(() => viewModel.updateCornerRadius(v)),
          ),
          _buildSlider(
            label: 'Corner Distortion',
            value: viewModel.cornerDistortion,
            min: 0,
            max: 3,
            onChanged: (v) => setState(() => viewModel.updateCornerDistortion(v)),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Liquid Glass',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanDown: (details) {
                final tapPos = details.localPosition;
                draggingIndex = viewModel.boxAtPoint(tapPos);
                if (draggingIndex != null) {
                  final box = viewModel.boxes[draggingIndex!];
                  dragOffset = tapPos - box.position;
                }
              },
              onPanUpdate: (details) {
                if (draggingIndex != null) {
                  final newPos = details.localPosition - dragOffset;
                  viewModel.updateBoxPosition(draggingIndex!, newPos);
                  setState(() {});
                }
              },
              onPanEnd: (_) {
                draggingIndex = null;
                setState(() {});
              },
              child: Stack(
                children: [
                  // Scrollable colorful boxes and images
                  Positioned.fill(
                    child: ListView(
                      children: [
                        const ColoredBox(
                          color: Colors.red,
                          child: SizedBox(height: 100),
                        ),
                        const ColoredBox(
                          color: Colors.blue,
                          child: SizedBox(height: 100),
                        ),
                        const ColoredBox(
                          color: Colors.green,
                          child: SizedBox(height: 100),
                        ),
                        const ColoredBox(
                          color: Colors.yellow,
                          child: SizedBox(height: 100),
                        ),
                        Image.network(
                          'https://media.istockphoto.com/id/471926619/pt/foto/lago-moraine-ao-nascer-do-sol-parque-nacional-de-banff-canad%C3%A1.jpg?s=1024x1024&w=is&k=20&c=YNQ6owq5JfIRcn1FF8WKj1HaIW6pNptJaw2FJzwcViM=',
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Image.network(
                          'https://picsum.photos/seed/glass/800/800',
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  // Clip & blur region
                  ClipPath(
                    clipper: UnionClipper(viewModel),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: viewModel.blurSigma,
                        sigmaY: viewModel.blurSigma,
                      ),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // Paint glass overlay
                  CustomPaint(
                    size: Size.infinite,
                    painter: LiquidGlassPainter(viewModel),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnionClipper extends CustomClipper<Path> {
  final LiquidGlassViewModel viewModel;

  UnionClipper(this.viewModel);

  @override
  Path getClip(Size size) {
    // Start with an empty path
    Path unionPath = Path();

    // For each box, build its rounded-rect path and union it in
    for (var box in viewModel.boxes) {
      final rect = Rect.fromLTWH(
        box.position.dx,
        box.position.dy,
        box.width,
        box.height,
      );
      final rrect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(viewModel.cornerRadius),
      );
      final path = Path()..addRRect(rrect);

      // Always union with the running 'unionPath'
      unionPath = Path.combine(
        PathOperation.union,
        unionPath,
        path,
      );
    }

    return unionPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

// class LiquidGlassPainter extends CustomPainter {
//   final LiquidGlassViewModel viewModel;
//   LiquidGlassPainter(this.viewModel);

//   @override
//   void paint(Canvas canvas, Size size) {
//     // 1) Build the union of all box shapes
//     Path unionPath = Path();
//     for (var box in viewModel.boxes) {
//       final rect = Rect.fromLTWH(
//         box.position.dx,
//         box.position.dy,
//         box.width,
//         box.height,
//       );
//       final rrect = RRect.fromRectAndRadius(
//         rect,
//         Radius.circular(viewModel.cornerRadius),
//       );
//       final path = Path()..addRRect(rrect);

//       unionPath = Path.combine(
//         PathOperation.union,
//         unionPath,
//         path,
//       );
//     }

//     // 2) Fill with gradient highlight
//     final bounds = unionPath.getBounds();
//     final gradient = LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [
//         Colors.white.withOpacity(0.3 * viewModel.lightIntensity),
//         Colors.white.withOpacity(0.1 * viewModel.lightIntensity),
//       ],
//     );
//     final paintFill = Paint()..shader = gradient.createShader(bounds);
//     canvas.drawPath(unionPath, paintFill);

//     // 3) Chromatic aberration (optional colored fringes)
//     if (viewModel.chromaticShift > 0) {
//       final shift = viewModel.chromaticShift;
//       final redPaint = Paint()
//         ..color = Colors.red.withOpacity(0.2)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = viewModel.thickness * 2;
//       canvas.drawPath(unionPath.shift(Offset(-shift, 0)), redPaint);

//       final bluePaint = Paint()
//         ..color = Colors.blue.withOpacity(0.2)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = viewModel.thickness * 2;
//       canvas.drawPath(unionPath.shift(Offset(shift, 0)), bluePaint);
//     }

//     // 4) White border around the merged shape
//     final borderPaint = Paint()
//       ..color = Colors.white.withOpacity(0.8)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = viewModel.thickness;
//     canvas.drawPath(unionPath, borderPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

class LiquidGlassPainter extends CustomPainter {
  final LiquidGlassViewModel viewModel;
  LiquidGlassPainter(this.viewModel);

  @override
  void paint(Canvas canvas, Size size) {
    Path unionPath = Path();
    for (var box in viewModel.boxes) {
      final rect = Rect.fromLTWH(
        box.position.dx,
        box.position.dy,
        box.width,
        box.height,
      );

      Path path;
      if (viewModel.cornerRadius > 0) {
        final rrect = RRect.fromRectAndRadius(
          rect,
          Radius.circular(viewModel.cornerRadius),
        );
        path = Path()..addRRect(rrect);
      } else {
        path = Path()..addRect(rect);
      }

      unionPath = Path.combine(
        PathOperation.union,
        unionPath,
        path,
      );
    }

    // 1. Draw blur background
    final blurPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, viewModel.blurSigma);
    canvas.drawPath(unionPath, blurPaint);

    // 2. Draw glass fill with corner distortion
    final bounds = unionPath.getBounds();
    final gradient = RadialGradient(
      //   center: bounds.center,
      radius: 0.7,
      colors: [
        Colors.white.withOpacity(0.4 * viewModel.lightIntensity),
        Colors.white.withOpacity(0.1 * viewModel.lightIntensity),
      ],
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(bounds)
      ..style = PaintingStyle.fill;
    canvas.drawPath(unionPath, fillPaint);

    // 3. Corner distortion effect
    final cornerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = viewModel.thickness * 2;

    for (var box in viewModel.boxes) {
      final rect = Rect.fromLTWH(
        box.position.dx,
        box.position.dy,
        box.width,
        box.height,
      );

      // Draw distorted corners
      _drawDistortedCorners(canvas, rect, viewModel);
    }

    // 4. Border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = viewModel.thickness;
    canvas.drawPath(unionPath, borderPaint);
  }

  void _drawDistortedCorners(Canvas canvas, Rect rect, LiquidGlassViewModel vm) {
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
    ];

    final cornerRadius = vm.cornerRadius;
    final distortion = vm.thickness * vm.cornerDistortion * 0.5;

    for (final corner in corners) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, distortion);

      canvas.drawCircle(
        corner,
        cornerRadius + distortion,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
