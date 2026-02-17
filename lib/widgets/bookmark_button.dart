import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';

class BookmarkButton extends StatefulWidget {
  final Article article;

  const BookmarkButton({super.key, required this.article});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {

  final NewsService _newsService = NewsService();
  bool _isSaved = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
  }

  Future<void> _checkSavedStatus() async {
    final saved = await _newsService.isArticleSaved(widget.article.articleUrl);
    if (mounted) {
      setState(() {
        _isSaved = saved;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    final previousState = _isSaved;
    setState(() {
      _isSaved = !_isSaved;
    });

    try {
      await _newsService.toggleBookmark(widget.article, previousState);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSaved ? 'Saved successfully' : 'Removed from saved items'),
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }catch (e) {
      setState(() {
        _isSaved = previousState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return GestureDetector(
      onTap: _toggleBookmark,
      child: Icon(
        _isSaved ? Icons.bookmark : Icons.bookmark_border,
        size: 26,
        color: _isSaved ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }
}