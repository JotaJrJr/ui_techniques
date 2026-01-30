import 'package:flutter/material.dart';


class GhostEffectDemo extends StatefulWidget {
  const GhostEffectDemo({super.key});

  @override
  State<GhostEffectDemo> createState() => _GhostEffectDemoState();
}

class _GhostEffectDemoState extends State<GhostEffectDemo> with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
  
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _showHint = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerHint() {
    setState(() {
      _showHint = true;
    });
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghost Effect'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bloco de cima
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              margin: const EdgeInsets.only(bottom: 50),
              child: const Center(
                child: Text(
                  'Destino',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // Bloco de baixo
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      'Origem',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Bloco Fantasma
                if (_showHint)
                  SlideTransition(
                    position: _offsetAnimation,
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.red,
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _triggerHint,
              child: const Text('Mostrar Dica'),
            ),
          ],
        ),
      ),
    );
  }
}