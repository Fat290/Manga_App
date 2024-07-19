import 'package:bloc/bloc.dart';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/models/page.dart';
import 'package:doan_cs3/repositories/fetch_manga.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'manga_event.dart';
part 'manga_state.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  final MangaRepositories mangaRepositories = MangaRepositories();
   Map<String, List<Manga>> allManga ={};
  MangaBloc() : super(MangaInitial()) {
    on<FetchAllManga>((event, emit)  async{
      emit(LoadingAllManga());
      try{
        final mangaLatest = await mangaRepositories.fetchLatestManga();
        final mangaAction = await mangaRepositories.fetchMangaData("Action","1");
        final mangaAdventure = await mangaRepositories.fetchMangaData("Adventure","2");
        final mangaComedy = await mangaRepositories.fetchMangaData("Comedy","3");
        final mangaDrama = await mangaRepositories.fetchMangaData("Drama","4");
        final mangaFantasy = await mangaRepositories.fetchMangaData("Fantasy","5");
        final mangaHorror = await mangaRepositories.fetchMangaData("Horror","1");
        final mangaMystery = await mangaRepositories.fetchMangaData("Mystery","2");
        final mangaRomance = await mangaRepositories.fetchMangaData("Romance","3");
        final mangaScifi = await mangaRepositories.fetchMangaData("Sci fi","4");
        final mangaSliceOfLife = await mangaRepositories.fetchMangaData("Slice of Life","5");
        final mangaSports = await mangaRepositories.fetchMangaData("Sports","1");
        final mangaSupernatural = await mangaRepositories.fetchMangaData("Supernatural","2");
        final mangaHistorical = await mangaRepositories.fetchMangaData("Historical","3");
        final mangaPsychological = await mangaRepositories.fetchMangaData("Psychological","4");
        final mangaMartialArts = await mangaRepositories.fetchMangaData("Martial Arts","4");
        final mangaShounen = await mangaRepositories.fetchMangaData("Shounen","5");
        final mangaShoujo = await mangaRepositories.fetchMangaData("Shoujo","1");
        final mangaSeinen = await mangaRepositories.fetchMangaData("Seinen","2");
        final mangaJosei = await mangaRepositories.fetchMangaData("Josei","3");
        final mangaHarem = await mangaRepositories.fetchMangaData("Harem","4");
        final mangaIsekai = await mangaRepositories.fetchMangaData("Isekai","5");

        allManga = {
          'Latest': mangaLatest,
          'Action': mangaAction,
          'Adventure': mangaAdventure,
          'Comedy': mangaComedy,
          'Drama': mangaDrama,
          'Fantasy': mangaFantasy,
          'Horror': mangaHorror,
          'Mystery': mangaMystery,
          'Romance': mangaRomance,
          'Sci fi': mangaScifi,
          'Slice of Life': mangaSliceOfLife,
          'Sports': mangaSports,
          'Supernatural': mangaSupernatural,
          'Historical': mangaHistorical,
          'Psychological': mangaPsychological,
          'Martial Arts': mangaMartialArts,
          'Shounen': mangaShounen,
          'Shoujo': mangaShoujo,
          'Seinen': mangaSeinen,
          'Josei': mangaJosei,
          'Harem': mangaHarem,
          'Isekai': mangaIsekai,
        };
        emit(LoadedAllManga(allManga));


      }
      catch(e){
        emit(LoadMangaFailure(e.toString()));
      }
    },

    );
    // on<FetchDetailManga>((event, emit) async {
    //    emit(LoadingAllManga());
    //    emit(LoadedAllManga(allManga));
    //    try{
    //      final mangaDetail = await mangaRepositories.fetchManga(event.mangaId);
    //
    //      emit(LoadedDetailManga(mangaDetail));
    //    }
    //    catch(e)
    //   {
    //     emit(LoadMangaFailure(e.toString()));
    //   }
    // },
    //
    // );
    // on<SearchManga>((event, emit) async {
    //   emit(LoadingAllManga());
    //   try{
    //     final searchManga = await mangaRepositories.searchManga(event.text);
    //     emit(LoadedSearchManga(searchManga));
    //   }
    //   catch(e)
    //   {
    //     emit(LoadMangaFailure(e.toString()));
    //   }
    // },
    //
    // );
  }


}

