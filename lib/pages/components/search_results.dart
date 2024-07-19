import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/bloc/search_manga/search_manga_bloc.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchMangaBloc, SearchMangaState>(
      builder: (context, state) {
        if (state is LoadingSearchManga) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedSearchMangaFailure) {
          return const Center(child: Text('Failed to load mangas'));
        } else if (state is LoadedSearchManga) {
          if (state.searchManga == null || state.searchManga.isEmpty) {
            return const Center(child: Text('No mangas found!'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("   Result",style: TextStyle(fontSize: 20),),
              SizedBox(height: 4,),
              Text("    "+state.searchManga.length.toString()+" results were found!"),
              SizedBox(height: 8,),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.searchManga.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        context.read<DetailMangaBloc>().add(FetchDetailManga(state.searchManga[index].id));
                        context.pushNamed("Detail_Manga",pathParameters: {'id':state.searchManga[index].id});
                      },
                      dense: true,
                      visualDensity: VisualDensity(vertical: 4),
                      title: Text(state.searchManga[index].title,style: TextStyle(fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                      subtitle: Text(state.searchManga[index].authors.first,maxLines: 1,overflow: TextOverflow.ellipsis),
                      leading: CachedImage(mangaThumb: state.searchManga[index].thumb,width: 100,height: 200,),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Select a genre to view mangas'));
        }
      },
    );
  }
}
