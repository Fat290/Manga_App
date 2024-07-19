class Chapter {
  final String id;
  final String mangaId;
  final String title;
  final int createdAt;
  final int updatedAt;

  Chapter({
    required this.id,
    required this.mangaId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      mangaId: json['manga'],
      title: json['title'],
      createdAt: json['create_at'],
      updatedAt: json['update_at'],
    );
  }
}
