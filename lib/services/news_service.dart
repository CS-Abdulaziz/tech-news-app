import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class NewsService {

  final String _apiKey = dotenv.env['NEWS_API_KEY']!;
  final String _baseUrl = dotenv.env['NEWS_API_BASE_url']!;

  static const String _techContextFilter = '(technology OR tech OR gadget OR software OR computing OR AI OR digital)';

  final _supabase = Supabase.instance.client;

  Future<List<Article>> fetchPersonalizedNews() async {
    try {
      final interests = await getUserInterests();
      String finalQuery;

      if (interests.isNotEmpty) {
        String interestsPart = '(${interests.join(' OR ')})';
        finalQuery = '$interestsPart AND $_techContextFilter';
      } else {
        finalQuery = 'technology';
      }

      final encodedQuery = Uri.encodeComponent(finalQuery);

      final url = Uri.parse(
        '$_baseUrl/everything?q=$encodedQuery&language=en&sortBy=publishedAt&pageSize=30&apiKey=$_apiKey'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List articlesJson = data['articles'];
        
        return articlesJson
            .where((json) => 
                json['title'] != null && 
                json['urlToImage'] != null && 
                json['url'] != null &&
                json['description'] != null
            )
            .map((json) => Article.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Article>> fetchNewsByTopic(String topic) async {
    try {
      if (topic.trim().isEmpty) return [];

      String finalQuery = '("$topic") AND $_techContextFilter';

      final encodedTopic = Uri.encodeComponent(finalQuery);

      final url = Uri.parse(
        '$_baseUrl/everything?q=$encodedTopic&language=en&sortBy=publishedAt&pageSize=20&apiKey=$_apiKey'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List articlesJson = data['articles'];
        
        return articlesJson
            .where((json) => 
                json['title'] != null && 
                json['urlToImage'] != null && 
                json['url'] != null &&
                json['description'] != null
            )
            .map((json) => Article.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load news for topic');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> getUserInterests() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase.from('user_interests').select('keyword').eq('user_id', userId);

      return (response as List).map((e) => e['keyword'].toString()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isArticleSaved(String articleUrl) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _supabase
          .from('bookmarks')
          .select('id')
          .eq('user_id', userId)
          .eq('url', articleUrl)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleBookmark(Article article, bool isCurrentlySaved) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    try {
      if (isCurrentlySaved) {
        await _supabase
            .from('bookmarks')
            .delete()
            .eq('user_id', userId)
            .eq('url', article.articleUrl);
      } else {
        await _supabase.from('bookmarks').insert({
          'user_id': userId,
          'title': article.title,
          'description': article.description,
          'url': article.articleUrl,
          'image_url': article.imageUrl,
          'source_name': article.sourceName,
          'published_at': article.publishedAt,
        });
      }
    } catch (e) {
       rethrow;
    }
  }

  Future<List<Article>> getBookmarkedArticles() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('bookmarks')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List data = response;
      
      return data.map((json) => Article(
        title: json['title'] ?? 'No Title',
        description: json['description'] ?? '',
        imageUrl: json['image_url'] ?? '',
        articleUrl: json['url'] ?? '',
        publishedAt: json['published_at'] ?? '',
        sourceName: json['source_name'] ?? 'Unknown',
      )).toList();
    } catch (e) {
      return [];
    }
  }
}