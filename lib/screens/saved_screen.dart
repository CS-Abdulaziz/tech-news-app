import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';
import '../widgets/bookmark_button.dart';
import 'article_details_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<Article>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    setState(() {
      _bookmarksFuture = _newsService.getBookmarkedArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          "Saved Articles",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, letterSpacing: -0.5),
        ),
      ),
      body: RefreshIndicator(
        color: theme.primaryColor,
        backgroundColor: theme.cardTheme.color,
        onRefresh: () async => _loadBookmarks(),
        child: FutureBuilder<List<Article>>(
          future: _bookmarksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: theme.primaryColor));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error loading bookmarks', style: TextStyle(color: theme.colorScheme.onSurface)));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No saved articles yet.', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16)));
            }

            final articles = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return _buildSavedItem(article, theme);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSavedItem(Article article, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleDetailsScreen(article: article),
            ),
          ).then((_) => _loadBookmarks());
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  article.imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    width: 100,
                    color: theme.cardTheme.color,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.sourceName,
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            article.publishedAt.substring(0, 10),
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          BookmarkButton(article: article),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}