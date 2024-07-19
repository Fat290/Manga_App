part of 'detail_manga_bloc.dart';

@immutable
sealed class DetailMangaEvent {
  const DetailMangaEvent();
  @override

  List<Object> get props => [];
}


class FetchDetailManga extends DetailMangaEvent{
  final String mangaId;
  const FetchDetailManga(this.mangaId);
  @override
  List<Object> get props => [mangaId];
}