part of 'manga_bloc.dart';

sealed class MangaEvent extends Equatable {
  const MangaEvent();
  @override

  List<Object> get props => [];
}
class FetchAllManga extends MangaEvent{}
class FetchListMangaByGenres extends MangaEvent{
  final String genres;
  const FetchListMangaByGenres(this.genres);
  @override
  List<Object> get props => [genres];
}

class FetchLatestManga extends MangaEvent{

}

// class FetchDetailManga extends MangaEvent{
//   final String mangaId;
//   const FetchDetailManga(this.mangaId);
//   @override
//   List<Object> get props => [mangaId];
// }

// class SearchManga extends MangaEvent
// {
//   final String text;
//   const SearchManga(this.text);
//   @override
//   List<Object> get props =>[text];
// }

class FetchChapter extends MangaEvent {
  final String mangaId ;
  const FetchChapter(this.mangaId);
  @override
  List<Object> get props => [mangaId];
}

class FetchImageChapter extends MangaEvent {
  final String chapterId;
  const FetchImageChapter(this.chapterId);
  @override
  List<Object> get props => [chapterId];
}
