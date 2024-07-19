part of 'chapter_bloc.dart';

@immutable
sealed class ChapterState {
  const ChapterState();
  @override
  List<Object> get props => [];
}

final class ChapterInitial extends ChapterState {}


final class LoadedChapter extends ChapterState{
  final List<Page> chapters ;
  const LoadedChapter(this.chapters);
  @override
  List<Object> get props => [chapters];
}

final class LoadingChapter extends ChapterState{
}

final class LoadedChapterFailed extends ChapterState{
  final String message;
  const LoadedChapterFailed(this.message);
  @override
  List<Object> get props => [message];
}