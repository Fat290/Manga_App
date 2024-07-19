part of 'chapter_bloc.dart';

@immutable
sealed class ChapterEvent {
  const ChapterEvent();
  @override

  List<Object> get props => [];
}



class FetchChapterId extends ChapterEvent{
  final String chapterId;
  const FetchChapterId(this.chapterId);
  @override
  List<Object> get props => [chapterId];
}