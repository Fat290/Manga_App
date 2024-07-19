class Manga {
  final String id;
  final String title;
  final String subTitle;
  final String status;
  final String thumb;
  final String summary;
  final List<String> authors;
  final List<String> genres;
  final bool nsfw;
  final String type;
  final int totalChapter;
  final int createdAt;
  final int updatedAt;

  Manga({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.status,
    required this.thumb,
    required this.summary,
    required this.authors,
    required this.genres,
    required this.nsfw,
    required this.type,
    required this.totalChapter,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'],
      title: json['title'],
      subTitle: json['sub_title'],
      status: json['status'],
      thumb: json['thumb'],
      summary: json['summary'],
      authors: List<String>.from(json['authors']),
      genres: List<String>.from(json['genres']),
      nsfw: json['nsfw'],
      type: json['type'],
      totalChapter: json['total_chapter'],
      createdAt: json['create_at'],
      updatedAt: json['update_at'],
    );
  }
}
