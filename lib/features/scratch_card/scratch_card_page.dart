import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'scratch_card_view_model.dart';

class _ScratchPainter extends CustomPainter {
  final ui.Image maskImage;
  final List<Offset> points;

  /// é o paint que vai 'limpar' a imagem/widget de cim a
  final Paint _eraser = Paint()
    ..blendMode = BlendMode.clear
    ..style = PaintingStyle.fill;

  _ScratchPainter(this.maskImage, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    /// salva o estado do canvas inciialmente pra desenha por cima
    canvas.saveLayer(rect, Paint());

    /// desenha máscara exata o overlay cinza
    canvas.drawImageRect(
      maskImage,
      Rect.fromLTWH(
        0,
        0,
        maskImage.width.toDouble(),
        maskImage.height.toDouble(),
      ),
      rect,
      Paint(),
    );

    /// desenha o circulo de ponta que vai 'limpar' a imagem
    for (final pt in points) {
      canvas.drawCircle(pt, 30, _eraser);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScratchPainter old) {
    return old.points.length != points.length;
  }
}

class ScratchCardPage extends StatefulWidget {
  const ScratchCardPage({Key? key}) : super(key: key);

  @override
  State<ScratchCardPage> createState() => _ScratchCardPageState();
}

class _ScratchCardPageState extends State<ScratchCardPage> {
  late ScratchViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = ScratchViewModel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _viewModel.captureOverlay(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scratch Card')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Revisitar, essa porra só atualiza quando dou hot reload"),
          Center(
              child: AnimatedBuilder(
            animation: _viewModel,
            builder: (_, __) {
              if (_viewModel.maskImage == null) {
                return RepaintBoundary(
                  key: _viewModel.boundaryKey,
                  child: cover(),
                );
              }

              return Stack(
                children: [
                  RepaintBoundary(
                    key: _viewModel.boundaryKey,
                    child: overlay(),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (details) => _viewModel.addPoint(details.globalPosition),
                    onPanStart: (details) => _viewModel.addPoint(details.globalPosition),
                    onPanEnd: (details) => _viewModel.addPoint(details.globalPosition),
                    onPanCancel: () => _viewModel.addPoint(Offset.zero),
                    onTap: () => _viewModel.clear(),
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: _ScratchPainter(_viewModel.maskImage!, _viewModel.points),
                    ),
                  ),
                ],
              );
            },
          )),
        ],
      ),
    );
  }

  Widget overlay() => Container(
        width: 300,
        height: 300,
        color: Colors.amber,
        alignment: Alignment.center,
        child: const Text(
          '🎉 Solta Carta Carai! 🎉',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );

  Widget cover() => Container(
        width: 300,
        height: 300,
        color: Colors.grey,
        child: const Center(child: Text('rebola aqui', style: TextStyle(fontSize: 20))),
      );
}
