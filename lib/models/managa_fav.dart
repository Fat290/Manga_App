class MangaFav {

  final int userId;
  final String mangaId;
  final String createdAt;
  final String updatedAt;

  MangaFav({
    required this.userId,
    required this.mangaId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MangaFav.fromJson(Map<String, dynamic> json) {
    return MangaFav(
      userId: json['user_id'],
      mangaId: json['manga_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}