class Book {
  const Book({
    required this.id,
    required this.title,
    required this.description,
    required this.pageCount,
    required this.excerpt,
    required this.publishDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.parse(json['id'].toString()),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pageCount: json['pageCount'] as int? ?? 0,
      excerpt: json['excerpt'] as String? ?? '',
      publishDate: json['publishDate'] as String? ?? '',
    );
  }

  final int id;
  final String title;
  final String description;
  final int pageCount;
  final String excerpt;
  final String publishDate;
}
