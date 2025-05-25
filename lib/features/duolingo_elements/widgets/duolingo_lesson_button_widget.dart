import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuolingoLessonButtonWidget extends StatefulWidget {
  final Widget child;
  final Color color;
  final GestureTapCallback onPressed;

  const DuolingoLessonButtonWidget({super.key, required this.child, required this.color, required this.onPressed});

  @override
  State<DuolingoLessonButtonWidget> createState() => _DuolingoLessonButtonWidgetState();
}

class _DuolingoLessonButtonWidgetState extends State<DuolingoLessonButtonWidget> {
  bool _isPressed = true;

  final Duration _duration = const Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleButton();
        widget.onPressed;
      },
      child: SizedBox(
        width: 80,
        height: 97, // ALTURA TOTAL
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // BASE
            Positioned(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // CORPO
            AnimatedPositioned(
              duration: _duration,
              bottom: 40,
              child: AnimatedContainer(
                duration: _duration,
                width: 80,
                height: _isPressed ? 20 : 0,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.8),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            // TOPO
            AnimatedPositioned(
              duration: _duration,
              top: _isPressed ? 2 : 17,
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO : Refazer com valores dinâmicos

  void _toggleButton() {
    setState(() {
      _isPressed = !_isPressed;
      HapticFeedback.lightImpact();
    });
  }
}
