class Page {
  final String id;
  final String chapterId;
  final String mangaId;
  final int index;
  final String link;

  Page({
    required this.id,
    required this.chapterId,
    required this.mangaId,
    required this.index,
    required this.link,
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      id: json['id'],
      chapterId: json['chapter'],
      mangaId: json['manga'],
      index: json['index'],
      link: json['link'],
    );
  }
}
