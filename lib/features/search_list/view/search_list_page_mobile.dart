import 'package:flutter/material.dart';
import 'package:ui_techniques/features/search_list/search_list_view_model.dart';

class SearchListPageMobile extends StatefulWidget {
  final SearchListViewModel viewModel;
  const SearchListPageMobile({super.key, required this.viewModel});

  @override
  State<SearchListPageMobile> createState() => _SearchListPageMobileState();
}

class _SearchListPageMobileState extends State<SearchListPageMobile> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                widget.viewModel.filter(value);
              },
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<SearchListModel>>(
              valueListenable: widget.viewModel.filteredList,
              builder: (_, list, __) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text("No results found"),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];

                    return ListTile(
                      title: TextHighlighter.hightlightSnippet(item.title, widget.viewModel.query),
                      subtitle: TextHighlighter.hightlightSnippet(item.subtitle, widget.viewModel.query),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchListResultPageMobile(
                                    model: item,
                                    query: widget.viewModel.query,
                                  )),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SearchListResultPageMobile extends StatelessWidget {
  final SearchListModel model;
  final String query;
  const SearchListResultPageMobile({super.key, required this.model, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextHighlighter.highlightFull(model.title, query),
            const SizedBox(height: 24),
            Text("Subtitle:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextHighlighter.highlightFull(model.subtitle, query),
          ],
        ),
      ),
    );
  }
}
