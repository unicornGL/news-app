class Article {
  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  final Source? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  factory Article.fromJson(Map<String, dynamic> json) {
    final sourceJson = json['source'];
    return Article(
      source: sourceJson != null
          ? (
              id: sourceJson['id'],
              name: sourceJson['name'],
            )
          : null,
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}

typedef Source = ({String? id, String? name});
