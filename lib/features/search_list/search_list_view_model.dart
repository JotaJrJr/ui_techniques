import 'package:flutter/material.dart';

class SearchListViewModel {
  List<SearchListModel> list = [
    SearchListModel(title: "Title 1", subtitle: "Subtitle 1"),
    SearchListModel(title: "Title 2", subtitle: "Subtitle 2"),
    SearchListModel(title: "Title 3", subtitle: "Subtitle 3"),
    SearchListModel(title: "Title 4", subtitle: "Subtitle 4"),
    SearchListModel(title: "Title 5", subtitle: "Subtitle 5"),
    SearchListModel(title: "Title 6", subtitle: "Subtitle 6"),
    SearchListModel(title: "Title 7", subtitle: "Subtitle 7"),
    SearchListModel(title: "Title 8", subtitle: "Subtitle 8"),
    SearchListModel(title: "Title 9", subtitle: "Subtitle 9"),
    SearchListModel(title: "Title 10", subtitle: "Subtitle 10"),
    SearchListModel(title: "Title 11", subtitle: "Um exemplo muito foda fazendo teste para ver se funciona"),
    // SearchListModel(title: "Title 12", subtitle: "Subtitle 12"),
    // SearchListModel(title: "Title 13", subtitle: "Subtitle 13"),
    // SearchListModel(title: "Title 14", subtitle: "Subtitle 14"),
    // SearchListModel(title: "Title 15", subtitle: "Subtitle 15"),
    // SearchListModel(title: "Title 16", subtitle: "Subtitle 16"),
    // SearchListModel(title: "Title 17", subtitle: "Subtitle 17"),
  ];

  String query = '';

  final ValueNotifier<List<SearchListModel>> filteredList = ValueNotifier([]);

  void init() {
    filteredList.value = List.from(list);
  }

  void filter(String q) {
    query = q;

    final trimmed = q.trim();

    if (trimmed.isEmpty) {
      filteredList.value = List.from(list);
      return;
    }

    final lower = trimmed.toLowerCase();
    filteredList.value = list.where((item) {
      return item.title.toLowerCase().contains(lower) || item.subtitle.toLowerCase().contains(lower);
    }).toList();
  }
}

class SearchListModel {
  final String title;
  final String subtitle;
  SearchListModel({
    required this.title,
    required this.subtitle,
  });
}

class TextHighlighter {
  static RichText hightlightSnippet(String text, String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final idx = lowerText.indexOf(lowerQuery);

    if (idx < 0) {
      return RichText(
        text: TextSpan(text: text, style: const TextStyle(color: Colors.black)),
      );
    }

    final start = idx - 10 < 0 ? 0 : idx - 10;
    final end = idx + lowerQuery.length + 10 > text.length ? text.length : idx + lowerQuery.length + 10;

    final snippet = text.substring(start, end);
    final lowerSnippet = snippet.toLowerCase();

    final matchStart = lowerSnippet.indexOf(lowerQuery);
    final matchEnd = matchStart + lowerQuery.length;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(text: snippet.substring(0, matchStart)),
          TextSpan(
            text: snippet.substring(matchStart, matchEnd),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.yellow,
            ),
          ),
          TextSpan(text: snippet.substring(matchEnd)),
        ],
      ),
    );
  }

  static RichText highlightFull(String text, String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return RichText(
        text: TextSpan(text: text, style: const TextStyle(color: Colors.black)),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final List<TextSpan> spans = [];
    int currentIndex = 0;

    while (currentIndex < text.length) {
      final matchIndex = lowerText.indexOf(lowerQuery, currentIndex);

      if (matchIndex == -1) {
        spans.add(TextSpan(text: text.substring(currentIndex)));
        break;
      }

      if (matchIndex > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, matchIndex)));
      }

      final matchText = text.substring(matchIndex, matchIndex + lowerQuery.length);

      if (matchText.toLowerCase() == lowerQuery) {
        spans.add(TextSpan(
            text: matchText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.yellow,
            )));
      } else {
        spans.add(TextSpan(text: matchText));
      }

      //   spans.add(
      //     TextSpan(
      //       text: text.substring(matchIndex, matchIndex + lowerQuery.length),
      //       style: const TextStyle(
      //         fontWeight: FontWeight.bold,
      //         backgroundColor: Colors.yellow,
      //       ),
      //     ),
      //   );

      currentIndex = matchIndex + lowerQuery.length;
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: spans,
      ),
    );
  }
}
