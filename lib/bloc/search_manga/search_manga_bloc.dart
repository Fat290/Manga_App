import 'package:bloc/bloc.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/repositories/fetch_manga.dart';
import 'package:meta/meta.dart';

part 'search_manga_event.dart';
part 'search_manga_state.dart';

class SearchMangaBloc extends Bloc<SearchMangaEvent, SearchMangaState> {
  final MangaRepositories mangaRepositories = MangaRepositories();
  SearchMangaBloc() : super(SearchMangaInitial()) {
    on<SearchManga>((event, emit) async{
      emit(LoadingSearchManga());
        try{
          final searchManga = await mangaRepositories.searchManga(event.text);
          emit(LoadedSearchManga(searchManga));
        }
        catch(e)
        {
          emit(LoadedSearchMangaFailure(e.toString()));
        }
      },);
    }
  }

