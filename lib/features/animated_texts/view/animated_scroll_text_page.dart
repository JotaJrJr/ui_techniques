import 'package:flutter/material.dart';
import 'package:ui_techniques/features/animated_texts/viewmodel/animated_scroll_text_view_model.dart';

class AnimatedScrollTextPage extends StatefulWidget {
  const AnimatedScrollTextPage({super.key});

  @override
  State<AnimatedScrollTextPage> createState() => _AnimatedScrollTextPageState();
}

class _AnimatedScrollTextPageState extends State<AnimatedScrollTextPage> {
  late AnimatedScrollTextViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AnimatedScrollTextViewModel();
  }

  double getFontSize(int index) {
    if (_viewModel.selectedIndex == index) {
      return 50;
    } else if (_viewModel.selectedIndex != null && (index == _viewModel.selectedIndex! - 1 || index == _viewModel.selectedIndex! + 1)) {
      return 40;
    } else {
      return 30;
    }
  }

  Color getTextColor(int index) {
    if (_viewModel.selectedIndex == index) {
      return Colors.orange;
    } else if (_viewModel.selectedIndex != null && (index == _viewModel.selectedIndex! - 1 || index == _viewModel.selectedIndex! + 1)) {
      return Colors.orange.withOpacity(0.8);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _viewModel.text.split('');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated Scroll Text"),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (_, __) {
          return Container(
            color: Colors.black,
            child: Center(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  _viewModel.startDrag(details.globalPosition);
                  setState(() {});
                },
                onHorizontalDragEnd: (_) {
                  _viewModel.stopDrag();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(data.length, (index) {
                    return TweenAnimationBuilder(
                      key: _viewModel.textKeys[index],
                      tween: Tween<double>(
                        begin: 30,
                        end: getFontSize(index),
                      ),
                      duration: const Duration(milliseconds: 100),
                      builder: (context, size, child) {
                        return Text(
                          data[index],
                          style: TextStyle(
                            color: getTextColor(index),
                            fontWeight: FontWeight.w800,
                            fontSize: size,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
