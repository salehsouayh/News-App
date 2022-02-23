class News {
  final String title;
  final String? source;
  final String urlImage;
  final String description;
  final String publishedAt;
  final String url;

  const News(
      {required this.title,
      required this.urlImage,
      this.source,
      required this.description,
      required this.publishedAt,
      required this.url});

  factory News.fromJson(Map<String, dynamic> json) => News(
      title: json['title'],
      urlImage: json['urlToImage'] ??
          'https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg',
      source: json['source']?['name'],
      description: json['description'],
      publishedAt: json['publishedAt'],
      url: json['url']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'urlImage': urlImage,
        'source': source,
        'description': description,
        'publishedAt': publishedAt,
        'url': url
      };
}
