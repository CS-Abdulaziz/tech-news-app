class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String articleUrl;
  final String publishedAt;
  final String sourceName;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.articleUrl,
    required this.publishedAt,
    required this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['urlToImage'] ?? '',
      articleUrl: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      sourceName: json['source']?['name'] ?? 'Unknown',
    );
  }
}