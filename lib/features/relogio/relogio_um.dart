import 'dart:async';

import 'package:flutter/material.dart';

class RelogioUm extends StatefulWidget {
  const RelogioUm({super.key});

  @override
  State<RelogioUm> createState() => _RelogioUmState();
}

class _RelogioUmState extends State<RelogioUm> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _secondController;

  Timer? _timer;

//   int selectedHour = 0;
//   int selectedMinute = 0;
//   int selectedSecond = 0;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _hourController = FixedExtentScrollController(initialItem: now.hour);
    _minuteController = FixedExtentScrollController(initialItem: now.minute);
    _secondController = FixedExtentScrollController(initialItem: now.second);

    // A cada segundo, sincroniza as rodas com a hora atual
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      //   debugPrint("${_hourController.selectedItem}");
      //   debugPrint("${_minuteController.selectedItem}");
      //   debugPrint("${_secondController.selectedItem}");

      final dt = DateTime.now();
      // use jumpToItem para não animar demais
      //   _hourController.jumpToItem(dt.hour);
      //   _minuteController.jumpToItem(dt.minute);
      //   _secondController.jumpToItem(dt.second);

      _hourController.animateToItem(dt.hour, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      _minuteController.animateToItem(dt.minute, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      _secondController.animateToItem(dt.second, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });

    // final now = DateTime.now();

    // _hourController = FixedExtentScrollController(initialItem: now.hour);
    // _minuteController = FixedExtentScrollController(initialItem: now.minute);
    // _secondController = FixedExtentScrollController(initialItem: now.second);

    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   final dt = DateTime.now();
    //   _hourController.jumpToItem(dt.hour);
    //   _minuteController.jumpToItem(dt.minute);
    //   _secondController.jumpToItem(dt.second);
    // });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relógio Um')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 65,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 0, 0, 0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //   child: ,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWheelList(
                          controller: _hourController,
                          items: List.generate(24, (index) => index),
                          //   onChanged: (value) {
                          //     setState(
                          //       () {
                          //         selectedHour = value;
                          //       },
                          //     );
                          //     //   widget.onTimeSelected?.call(selectedHour, selectedMinute, selectedSecond);
                          //   },
                        ),
                        // const SizedBox(width: 10),
                        const Text(
                          ":",
                          style: TextStyle(fontSize: 24),
                        ),
                        _buildWheelList(
                          controller: _minuteController,
                          items: List.generate(60, (index) => index),
                          //   onChanged: (value) {
                          //     setState(
                          //       () {
                          //         selectedMinute = value;
                          //       },
                          //     );
                          //     //   widget.onTimeSelected?.call(selectedHour, selectedMinute, selectedSecond);
                          //   },
                        ),
                        // const SizedBox(width: 10),
                        const Text(
                          ":",
                          style: TextStyle(fontSize: 24),
                        ),
                        _buildWheelList(
                          controller: _secondController,
                          items: List.generate(60, (index) => index),
                          //   onChanged: (value) {
                          //     setState(
                          //       () {
                          //         selectedSecond = value;
                          //       },
                          //     );
                          //     //   widget.onTimeSelected?.call(selectedHour, selectedMinute, selectedSecond);
                          //   },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//   Widget _buildBottomButton() {}

  Widget _buildWheelList({
    required FixedExtentScrollController controller,
    required List<int> items,
    // required Function(int) onChanged,
  }) {
    return SizedBox(
      width: 70,
      height: 74,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 80,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.005,
        diameterRatio: 1.0,
        childDelegate: ListWheelChildBuilderDelegate(
            childCount: items.length,
            builder: (context, index) {
              return Center(
                child: Text(
                  items[index].toString().padLeft(2, '0'),
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }),
      ),
    );
  }
}
