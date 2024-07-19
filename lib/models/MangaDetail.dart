import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/manga.dart';

class MangaDetail {
  final Manga mangaInformation;
  final List<Chapter> mangaChapters;

  MangaDetail(this.mangaInformation, this.mangaChapters);
}
