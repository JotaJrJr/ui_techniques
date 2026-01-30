import 'package:flutter/material.dart';

class SimpleContainerTransitionPage extends StatefulWidget {
  const SimpleContainerTransitionPage({super.key});

  @override
  State<SimpleContainerTransitionPage> createState() => _SimpleContainerTransitionPageState();
}

class _SimpleContainerTransitionPageState extends State<SimpleContainerTransitionPage> {

  late PageController _pageController;

  double _progress = 0;


  @override
  void initState() {
    super.initState();
    

    _pageController = PageController()
          ..addListener(() {
            setState(() {
              _progress = _pageController.page ?? 0;
            });
          });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Container Transition'),
      ),
      body: SizedBox(
        height: 400 + _progress * 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                const SizedBox(height: 16,),
                Expanded(child: PageView(
                  controller: _pageController,
                  children: const [
                    FirstContent(),
                    SecondContent()
                  ],
                ))
              ],
            )
          ],
        ),
      )
    );
  }
}

class FirstContent extends StatelessWidget {
  // final VoidCallback
  const FirstContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Muito Conteúdo'),
        Text('Outra coisa Legal'),

        // TextButton(onPressed: () {}, child: child)
      ],
    );
  }
}

class SecondContent extends StatelessWidget {
  const SecondContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            label: Text('Email'),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            label: Text('Senha'),
          ),
        ),
      ],
    );
  }
}