import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {

  static final String _apiKey = dotenv.env['AI_API_KEY']!;

  late final GenerativeModel _model;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> summarize(String title, String description) async {

    try {
      final promptText = '''
        You are an expert tech news editor.
        Here is data for a tech article:
        - Title: "$title"
        - Description: "$description"

      Task:
      Based only on the title and description, formulate the gist of the news in English.
      - Understand the tech context and write in clear, professional In arabic.
      - Summarize into 2 to 3 short, direct key points (use • at the start of each point).
      - Make the style engaging for tech news readers.
      - DO NOT add any introductory remarks like "Here is the summary", "إليك صياغة الخبر", or "بناء على طلبك". (لا تضف أي مقدمات إطلاقاً).
      - add a one line space between each full point.

      ''';

      final content = [Content.text(promptText)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Sorry, I could not summarize this article.';

    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'An error occurred while connecting to the AI service. Please check your internet connection.';
    }
  }
}