import 'package:flutter/material.dart';

class DuolingoListPage extends StatelessWidget {
  final List<String> items = List.generate(10, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake-Like List'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: items.asMap().entries.map((entry) {
              int index = entry.key;
              String item = entry.value;

              return Align(
                alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: 200, // Set your preferred width
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DuolingoListPage(),
  ));
}
// import 'package:flutter/material.dart';


// import 'package:ui_techniques/features/duolingo_elements/models/learning_unit_model.dart';
// import 'package:ui_techniques/features/duolingo_elements/widgets/duolingo_lesson_button_widget.dart';

// import '../viewmodel/duolingo_list_view_model.dart';

// class DuolingoListPage extends StatefulWidget {
//   const DuolingoListPage({super.key});

//   @override
//   State<DuolingoListPage> createState() => _DuolingoListPageState();
// }

// class _DuolingoListPageState extends State<DuolingoListPage> {
//   late DuolingoListViewModel _viewModel;

//   @override
//   void initState() {
//     super.initState();
//     _viewModel = DuolingoListViewModel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Duolingo ListView"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           itemCount: _viewModel.units.length,
//           itemBuilder: (context, index) {
//             final LearningUnitModel unit = _viewModel.units[index];

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   "Unit ${unit.unit}: ${unit.description}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: unit.lessonAmount,
//                   itemBuilder: (context, lessonIndex) {
//                     return Padding(
//                       padding: _calculatePadding(index, unit.lessonAmount),
//                       child: DuolingoLessonButtonWidget(
//                         color: Colors.red,
//                         onPressed: () {},
//                         child: const Icon(Icons.settings),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   EdgeInsets _calculatePadding(int index, int totalItems) {
//     // Primeiro e último tem que tá no centro
//     if (index == 0 || index == totalItems - 1) {
//       return const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0);
//     }

//     final isEven = index % 2 == 0;

//     return EdgeInsets.only(
//       left: isEven ? 60.0 : 20.0,
//       right: isEven ? 20.0 : 60,
//       top: 16.0,
//       bottom: 16.0,
//     );
//   }
// }
