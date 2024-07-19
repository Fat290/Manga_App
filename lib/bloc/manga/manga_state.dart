part of 'manga_bloc.dart';

sealed class MangaState extends Equatable {
  const MangaState();
  @override
  List<Object> get props => [];
}

final class MangaInitial extends MangaState {

}


final class LoadingAllManga extends MangaState{}
//initial
final class LoadedAllManga extends MangaState{
  final Map<String,List<Manga>> allManga;
  const LoadedAllManga(this.allManga);
  @override
  List<Object> get props => [allManga];
}

final class LoadedLatest extends MangaState{
  final List<Manga> latestManga;
  const LoadedLatest(this.latestManga);
  @override
  List<Object> get props => [latestManga];
}

// final class LoadedSearchManga extends MangaState{
//   final List<Manga> searchManga;
//   const LoadedSearchManga(this.searchManga);
//   @override
//   List<Object> get props => [searchManga];
// }

final class LoadedByGenres extends MangaState{
  final List<Manga> mangaGenres;
  const LoadedByGenres(this.mangaGenres);
  @override
  List<Object> get props => [mangaGenres];
}

final class LoadedChapter extends MangaState{
  final List<Chapter> chapter;

  const LoadedChapter(this.chapter);
  @override
  List<Object> get props =>[chapter];
}

final class LoadedChapterImage extends MangaState{
  final List<Page> chapterImage;

  const LoadedChapterImage(this.chapterImage);
  @override
  List<Object> get props =>[chapterImage];
}

final class LoadMangaFailure extends MangaState{
  final String message;
  const LoadMangaFailure(this.message);
  @override
  List<Object> get props => [message];
}