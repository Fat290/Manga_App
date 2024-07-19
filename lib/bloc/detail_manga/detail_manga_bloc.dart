import 'package:bloc/bloc.dart';
import 'package:doan_cs3/models/MangaDetail.dart';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/repositories/fetch_manga.dart';
import 'package:meta/meta.dart';

part 'detail_manga_event.dart';
part 'detail_manga_state.dart';

class DetailMangaBloc extends Bloc<DetailMangaEvent, DetailMangaState> {
  final MangaRepositories mangaRepositories = MangaRepositories();
  DetailMangaBloc() : super(DetailMangaInitial()) {
    on<FetchDetailManga>((event, emit) async {
      emit(LoadingDetailManga());
      try{
        final Manga mangaDetailInformation = await mangaRepositories.fetchManga(event.mangaId);
        final List<Chapter> mangaDetailChapter = await mangaRepositories.fetchChapter(event.mangaId);
        final MangaDetail mangaDetail = MangaDetail(mangaDetailInformation, mangaDetailChapter);
        emit(LoadedDetailManga(mangaDetail));
      }
      catch(e)
      {
        emit(LoadDetailMangaFailure(e.toString()));
      }
    },
    );
  }
}
