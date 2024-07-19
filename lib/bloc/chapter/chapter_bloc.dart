import 'package:bloc/bloc.dart';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/page.dart';
import 'package:doan_cs3/repositories/fetch_manga.dart';
import 'package:meta/meta.dart';

part 'chapter_event.dart';
part 'chapter_state.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final MangaRepositories mangaRepositories = MangaRepositories();
  ChapterBloc() : super(ChapterInitial()) {
    on<FetchChapterId>((event, emit) async{
      emit(LoadingChapter());
      try{
         final List<Page> chapters = await mangaRepositories.fetchImageChapter(event.chapterId);
         emit(LoadedChapter(chapters));
      }
      catch(e){
       emit(LoadedChapterFailed(e.toString()));
      }
    });
  }
}
