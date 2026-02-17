import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';
import 'news_tile.dart'; 

class NewsSearchDelegate extends SearchDelegate {
  final NewsService _newsService = NewsService();

  @override
  String? get searchFieldLabel => 'Search news...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: theme.iconTheme,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return buildSuggestions(context);
    }

    return FutureBuilder<List<Article>>(
      future: _newsService.fetchNewsByTopic(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error searching for news.'));
        }

        final articles = snapshot.data ?? [];

        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('No results found for "$query"', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return NewsTile(article: articles[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.travel_explore, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Type to search global tech news', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}