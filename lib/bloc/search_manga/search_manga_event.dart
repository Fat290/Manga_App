part of 'search_manga_bloc.dart';

@immutable
sealed class SearchMangaEvent {
  const SearchMangaEvent();
  @override

  List<Object> get props => [];
}

class SearchManga extends SearchMangaEvent
{
  final String text;
  const SearchManga(this.text);
  @override
  List<Object> get props =>[text];
}
