part of 'search_manga_bloc.dart';

@immutable
sealed class SearchMangaState {
  const SearchMangaState();
  @override
  List<Object> get props => [];
}

final class SearchMangaInitial extends SearchMangaState {}


final class LoadedSearchManga extends SearchMangaState{
  final List<Manga> searchManga;
  const LoadedSearchManga(this.searchManga);
  @override
  List<Object> get props => [searchManga];
}

final class LoadingSearchManga extends SearchMangaState{}
final class LoadedSearchMangaFailure extends SearchMangaState{
  final String message;
  const LoadedSearchMangaFailure(this.message);
  @override
  List<Object> get props => [message];
}