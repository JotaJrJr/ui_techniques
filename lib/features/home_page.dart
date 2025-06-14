import 'package:flutter/material.dart';
import 'package:ui_techniques/features/animated_texts/view/animated_scroll_text_page.dart';
import 'package:ui_techniques/features/animated_widgets/animated_widgets.dart';
import 'package:ui_techniques/features/animated_widgets/animated_widgets_view_model.dart';
import 'package:ui_techniques/features/duolingo_elements/view/duolingo_list_page.dart';
import 'package:ui_techniques/features/duolingo_elements/view/zig_zag_list_page.dart';
import 'package:ui_techniques/features/relogio/relogio_um.dart';
import 'package:ui_techniques/features/scratch_card/scratch_card_page.dart';
import 'package:ui_techniques/features/search_list/search_list_view_model.dart';
import 'package:ui_techniques/features/search_list/view/search_list_page_mobile.dart';
import 'package:ui_techniques/features/wheel/models/prize_model.dart';
import 'package:ui_techniques/features/wheel/view/spinning_wheel_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: _viewModel.pages.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final NavigateToModel item = _viewModel.pages[index];

            return ListTile(
              onTap: () => _navigateToPage(item.page),
              title: Text(item.text ?? ""),
            );
          },
        ),
      ),
    );
  }

  _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

class HomeViewModel {
  List<NavigateToModel> pages = [
    NavigateToModel(text: "Duolingo ListView", page: DuolingoListPage()),
    NavigateToModel(text: "ZigZag", page: const ZigZagListPage()),
    NavigateToModel(text: "Animated Scroll Text", page: const AnimatedScrollTextPage()),
    NavigateToModel(
      text: "Spinning Wheel",
      page: SpinningWheel(
        prizes: [
          Prize(name: 'Prize 1', color: Colors.red),
          Prize(name: 'Prize 2', color: Colors.blue),
          Prize(name: 'Prize 3', color: Colors.green),
          Prize(name: 'Prize 4', color: Colors.yellow),
          Prize(name: 'Prize 5', color: Colors.orange),
          Prize(name: 'Prize 6', color: Colors.purple),
        ],
        size: 300,
        spinDuration: const Duration(seconds: 4),
      ),
    ),
    NavigateToModel(text: "Scratch Card", page: const ScratchCardPage()),
    NavigateToModel(text: "Relógio 1", page: const RelogioUm()),
    NavigateToModel(
        text: "Search List 1",
        page: SearchListPageMobile(
          viewModel: SearchListViewModel(),
        )),
    NavigateToModel(
      text: "Animated Widgets",
      page: AnimatedWidgets(
        viewModel: AnimatedWidgetsViewModel(),
      ),
    ),
  ];
}

class NavigateToModel {
  final String text;
  final Widget page;

  NavigateToModel({
    required this.text,
    required this.page,
  });
}
