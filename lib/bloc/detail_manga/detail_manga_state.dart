part of 'detail_manga_bloc.dart';

@immutable
sealed class DetailMangaState {
  const DetailMangaState();
  @override
  List<Object> get props => [];
}

final class DetailMangaInitial extends DetailMangaState {}

final class LoadedDetailManga extends DetailMangaState{
  final MangaDetail detailManga;
  const LoadedDetailManga(this.detailManga);
  @override
  List<Object> get props => [detailManga];
}

final class LoadingDetailManga extends DetailMangaState{
}

final class LoadDetailMangaFailure extends DetailMangaState{
  final String message;
  const LoadDetailMangaFailure(this.message);
  @override
  List<Object> get props => [message];
}