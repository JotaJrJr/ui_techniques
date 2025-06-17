import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_techniques/features/liquid_glass/liquid_glass_view_model.dart';

import 'liquid_glass_painter.dart';

class LiquidGlassPage extends StatefulWidget {
  const LiquidGlassPage({super.key});

  @override
  State<LiquidGlassPage> createState() => _LiquidGlassPageState();
}

class _LiquidGlassPageState extends State<LiquidGlassPage> {
  late LiquidGlassViewModel viewModel;

  int? draggingIndex;
  Offset dragOffset = Offset.zero;

  void checkShaderAsset() async {
    try {
      final data = await rootBundle.load('assets/shaders/liquid_glass_shader.frag');
      debugPrint('Shader file size: ${data.lengthInBytes} bytes');

      if (data.lengthInBytes == 0) {
        debugPrint('Vazio');
      } else {
        debugPrint('${data.lengthInBytes} bytes');
        debugPrint('Content começa com ${String.fromCharCodes(data.buffer.asUint8List(0, 20))}');
      }
    } catch (e) {
      debugPrint('deu ruim geral $e nessa merda');
    }
  }

  @override
  void initState() {
    super.initState();
    checkShaderAsset();
    viewModel = LiquidGlassViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadShader();
    });
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
                    child: _buildBackgroundContent(),
                  ),

                  //   Positioned.fill(
                  //     child: ListView(
                  //       children: [
                  //         const ColoredBox(
                  //           color: Colors.red,
                  //           child: SizedBox(height: 100),
                  //         ),
                  //         const ColoredBox(
                  //           color: Colors.blue,
                  //           child: SizedBox(height: 100),
                  //         ),
                  //         const ColoredBox(
                  //           color: Colors.green,
                  //           child: SizedBox(height: 100),
                  //         ),
                  //         const ColoredBox(
                  //           color: Colors.yellow,
                  //           child: SizedBox(height: 100),
                  //         ),
                  //         Image.network(
                  //           'https://media.istockphoto.com/id/471926619/pt/foto/lago-moraine-ao-nascer-do-sol-parque-nacional-de-banff-canad%C3%A1.jpg?s=1024x1024&w=is&k=20&c=YNQ6owq5JfIRcn1FF8WKj1HaIW6pNptJaw2FJzwcViM=',
                  //           height: 200,
                  //           fit: BoxFit.cover,
                  //         ),
                  //         Image.network(
                  //           'https://picsum.photos/seed/glass/800/800',
                  //           height: 200,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
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
                  LayoutBuilder(builder: (context, constraints) {
                    final shader = viewModel.getShader(constraints.biggest);

                    return CustomPaint(
                      size: Size.infinite,
                      painter: LiquidGlassPainter(viewModel, shader: shader),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundContent() {
    return ListView(
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
