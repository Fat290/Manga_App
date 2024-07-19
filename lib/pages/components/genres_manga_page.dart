import 'dart:math';

import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GenresMangaPage extends StatefulWidget  {
  const GenresMangaPage({
    super.key,
    required this.genres,
    required this.tabController,
  });
  final String genres;
  final TabController tabController;

  @override
  State<GenresMangaPage> createState() => _GenresMangaPageState();
}

class _GenresMangaPageState extends State<GenresMangaPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MangaBloc, MangaState>(
      builder: (context, state) {
        if (state is LoadingAllManga) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadMangaFailure) {
          return const Center(child: Text('Failed to load mangas'));
        } else if (state is LoadedAllManga) {
          if (state.allManga[widget.genres] == null) {
            return const Center(child: Text('No mangas found for this genre'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: state.allManga[widget.genres]!.length,
            itemBuilder: (context, index) {
              final manga = state.allManga[widget.genres]?[index];
              var random = Random();
              int min = 10;
              int max = 50;
              double randomDouble = min.toDouble() + random.nextInt(max - min);
              return GestureDetector(
                onTap:(){
                  context.read<DetailMangaBloc>().add(FetchDetailManga(manga.id));
                  // BlocProvider.of<MangaBloc>(context).add(FetchDetailManga(manga.id));
                  context.pushNamed("Detail_Manga",pathParameters: {'id':manga.id});
                  //   context.push(context.namedLocation("Detail_Manga",pathParameters: {'id':manga.id}));
                  // context.goNamed("Detail_Manga",pathParameters: {'id':manga.id});
                },
                child: Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                   child: Row(
                     children: [
                       CachedImage(mangaThumb: manga!.thumb, height: 150, width: 120),

                       Expanded(
                         child: Padding(
                           padding: const EdgeInsets.only(left: 14,right: 4,top: 20),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Text(manga.title,
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 1,
                                     style: const TextStyle(
                                       fontWeight: FontWeight.bold,
                                       fontSize: 14.0,
                                     ),
                               ),
                               const SizedBox(height: 4,),
                               Row(
                                 children: [
                                   Icon(Icons.favorite,color: Theme.of(context).colorScheme.primary,size: 10,),
                                   const SizedBox(width: 2,),
                                   Text(randomDouble.toString()+"M",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 10),)
                                 ],
                               ),
                               const SizedBox(height: 8,),
                               Text(
                                 manga.summary ?? 'No description available',
                                 maxLines: 3,
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(
                                   fontSize:  10,
                                   color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
                                 ),
                               )
                             ],

                           ),
                         ),
                       ),

                     ],
                   )
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('Select a genre to view mangas'));
        }
      },
    );
  }

}
