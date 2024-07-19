import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RankingGenres extends StatefulWidget {
  const RankingGenres(
      {super.key, required this.genres});

  // final TabController tabController;
  final String genres;

  @override
  State<RankingGenres> createState() => _RankingGenresState();
}

class _RankingGenresState extends State<RankingGenres> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MangaBloc, MangaState>(builder: (context, state) {
      if (state is LoadingAllManga) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is LoadMangaFailure) {
        return const Center(child: Text('Failed to load mangas'));
      } else if (state is LoadedAllManga) {
        if (state.allManga[widget.genres] == null) {
          return const Center(child: Text('No mangas found for this genre'));
        }

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5), ))
              ),
              width: double.infinity,
              height: 200,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CachedImage(
                              mangaThumb: state.allManga[widget.genres]![0].thumb,
                              height: 150,
                              width: 120),
                        ),

                       Positioned(
                            top: 25,
                            left: 2,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child:  Icon(Icons.star,size: 40,color: Theme.of(context).colorScheme.primary,),
                                ),
                                const Positioned(
                                  top: 8,
                                  left: 16,
                                    child:  Text(
                                      "1",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),

                                )
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14,right: 4,top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.allManga[widget.genres]![0].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                          const SizedBox(height: 4,),
                          Row(
                            children: [
                              Icon(Icons.favorite,color: Theme.of(context).colorScheme.primary,size: 10,),
                              const SizedBox(width: 2,),
                              Text("52.3"+"M",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 10),),
                              const SizedBox(width: 8,),
                              Icon(Icons.star,color: Theme.of(context).colorScheme.primary,size: 10,),
                              const SizedBox(width: 2,),
                              Text("52.3"+"M",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 10),)
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Text(state.allManga[widget.genres]![0].summary,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(

                                fontSize: 10,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.7),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),

                itemCount: state.allManga[widget.genres]!.length-1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap:(){
                        context.read<DetailMangaBloc>().add(FetchDetailManga(state.allManga[widget.genres]![index+1].id));
                        context.push(context.namedLocation("Detail_Manga",pathParameters: {'id':state.allManga[widget.genres]![index+1].id}));
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Text("${index+2}",style: TextStyle(
                              fontSize: 24,

                            ),),
                            SizedBox(width: 16,),
                            CachedImage(mangaThumb: state.allManga[widget.genres]![index+1].thumb, height: 80, width: 80),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(state.allManga[widget.genres]![index+1].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )),
                                  const SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      Icon(Icons.favorite,color: Theme.of(context).colorScheme.primary,size: 10,),
                                      const SizedBox(width: 2,),
                                      Text("52.3"+"M",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 10),),
                                      const SizedBox(width: 8,),
                                      Icon(Icons.star,color: Theme.of(context).colorScheme.primary,size: 10,),
                                      const SizedBox(width: 2,),
                                      Text("52.3"+"M",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 10),)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      } else {
        return const Center(child: Text('Select a genre to view mangas'));
      }
    });
  }
}
