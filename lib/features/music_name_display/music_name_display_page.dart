import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ui_techniques/features/music_name_display/music_name_display_view_model.dart';

class MusicNameDisplayPage extends StatefulWidget {
  const MusicNameDisplayPage({super.key});

  @override
  State<MusicNameDisplayPage> createState() => _MusicNameDisplayPageState();
}

class _MusicNameDisplayPageState extends State<MusicNameDisplayPage> {
  late MusicNameDisplayViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = MusicNameDisplayViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Name"),
      ),
      body: Center(
        child: Container(
            width: 250,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: MarqueeText(
                text: 'Texto pra caraio late mecum não sie o que preciso de um emprego beijo e abraço',
                style: TextStyle(fontSize: 20),
                pauseDuration: Duration(seconds: 3),
                scrollDuration: Duration(seconds: 5),
                blankSpace: 30.0,
                fadeWidth: 20.0,
              ),
            )),
      ),
    );
  }
}

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration pauseDuration;
  final Duration scrollDuration;
  final double blankSpace;
  final double fadeWidth;

  const MarqueeText({
    super.key,
    required this.text,
    this.style,
    this.pauseDuration = const Duration(seconds: 2),
    this.scrollDuration = const Duration(seconds: 5),
    this.blankSpace = 20.0,
    this.fadeWidth = 16.0,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  final ScrollController _scrollController = ScrollController();

  bool get _hasScrolled => _scrollController.hasClients && _scrollController.offset > 0;

  final GlobalKey _textKey = GlobalKey();

  double _textWidth = 0.0;
  double _containerWidth = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startIfNeeded());
    _scrollController.addListener(() {
      final newHasScrolled = _scrollController.offset > 0.0;
      if (newHasScrolled != _hasScrolled) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _startIfNeeded() {
    final RenderBox? textBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? parentBox = context.findRenderObject() as RenderBox?;

    // é loucura mas isso serve para você saber os pixels de tamanho
    //no caso eu pego o tamanho do texto e o tamanho do container e
    //se o texto for maior que o container, eu inicio o scroll

    if (textBox == null || parentBox == null) return;

    _textWidth = textBox.size.width;
    _containerWidth = parentBox.size.width;

    if (_textWidth > _containerWidth) {
      _scheduleScroll();
    }
  }

  void _scheduleScroll() {
    _timer?.cancel();
    _timer = Timer(widget.pauseDuration, () async {
      final maxScroll = _scrollController.position.maxScrollExtent + widget.blankSpace;
      // eu faço um calculo para saber o tamanho do texto + o espaço em branco
      // que eu dei para o texto andar

      final maxScrollWithFade = maxScroll + widget.fadeWidth;
      await _scrollController.animateTo(
        maxScrollWithFade,
        duration: widget.scrollDuration,
        curve: Curves.linear,
      );

      _scrollController.jumpTo(0.0);
      _scheduleScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ShaderMask(
        shaderCallback: (bounds) {
          if (_hasScrolled) {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [0.0, 0.05, 0.95, 1.0],
            ).createShader(bounds);
          } else {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [
                0.0,
                0.95,
                1.0,
              ],
            ).createShader(bounds);
          }
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              Text(
                widget.text,
                key: _textKey,
                style: widget.style,
              ),
              SizedBox(
                width: widget.blankSpace,
              )
            ],
          ),
        ),
      ),
    );
  }
}
