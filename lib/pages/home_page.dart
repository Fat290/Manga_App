import 'dart:math';

import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/pages/components/banner.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:doan_cs3/pages/components/footer.dart';
import 'package:doan_cs3/pages/components/infinite_silder.dart';
import 'package:doan_cs3/pages/components/loading_page.dart';
import 'package:doan_cs3/pages/components/menu_items.dart';
import 'package:doan_cs3/pages/components/my_avatars.dart';
import 'package:doan_cs3/pages/components/my_carousel.dart';
import 'package:doan_cs3/pages/explore_page.dart';
import 'package:doan_cs3/repositories/fetch_manga.dart';
import 'package:doan_cs3/repositories/post_service.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MangaRepositories mangaRepositories = MangaRepositories();
  late PageController pageController;
  late String userName;

  // void _getUserName() async{
  //    userName = await getUserName();
  // }
  @override
  void initState() {

    super.initState();
    pageController = PageController(viewportFraction: 1.0, keepPage: true);
    // _getUserName();
    // context.read<MangaBloc>().add(FetchAllManga());
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: BlocBuilder<MangaBloc, MangaState>(
              builder: (context, state) {
                if (state is LoadingAllManga) {
                  return const Center(child: LoadingAnimation());
                } else if (state is LoadMangaFailure) {
                  return const Center(child: Text('Failed to load mangas'));
                } else if (state is LoadedAllManga) {
                  final latestMangaList = state.allManga['Latest'];
                  if (latestMangaList == null || latestMangaList.isEmpty) {
                    return const Center(
                        child: Text('No mangas found for this genre'));
                  }
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        shrinkWrap: true,
                        children:[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //avt
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      child: const MyAvatar(),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome back!",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary
                                                  .withOpacity(0.75)),
                                        ),
                                        Text(
                                          "Phat Le",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Theme.of(context).colorScheme.primary),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                //menu button
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Builder(
                                      builder: (context) {
                                        return GestureDetector(
                                          // onTap: () {
                                          //   showPopover(
                                          //     context: context,
                                          //     bodyBuilder: (context) => const MenuItem(),
                                          //     onPop: () => print('Popover was popped!'),
                                          //     direction: PopoverDirection.bottom,
                                          //     backgroundColor: Theme.of(context)
                                          //         .colorScheme
                                          //         .inversePrimary
                                          //         .withOpacity(0.75),
                                          //     width: 300,
                                          //     height: 400,
                                          //     arrowHeight: 0,
                                          //     arrowWidth: 0,
                                          //     radius: 50,
                                          //     contentDxOffset: -300,
                                          //     popoverTransitionBuilder: (animation, child) {
                                          //       return SlideTransition(
                                          //         position: Tween<Offset>(
                                          //           begin: const Offset(200, 0),
                                          //           // popover bắt đầu từ dưới
                                          //           end: Offset.zero,
                                          //         ).animate(animation),
                                          //         child: child,
                                          //       );
                                          //     },
                                          //   );
                                          // },
                                          child: Icon(
                                            Icons.notifications_none,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary
                                                .withOpacity(0.75),
                                            size: 30,
                                          ),
                                        );
                                      },
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Latest Manga",
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                     GestureDetector(child: Icon(Icons.arrow_forward_ios,size: 14,),
                                       onTap: (){
                                          context.pushNamed("Latest");
                                       },
                                     )
                                  ],
                                ),
                              ),
                              Center(
                                child: InfiniteSlider(
                                iteamCount: latestMangaList.length,
                                itemBuilder: (context, index) {
                                  return CachedImage(mangaThumb: state.allManga["Latest"]![index].thumb, height: 300, width: 220);
                                },
                                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100,),
                          Recommend(manga: state.allManga["Shounen"]!),
                          const SizedBox(height: 20,),
                          SliderP(),
                          const SizedBox(height: 50,),
                          Container(
                            height:650,
                            width: double.maxFinite,
                            child: PageView.builder(
                                itemBuilder: (context, index) {
                                  return TopM(manga: state.allManga[mangaGenres[index][0]]!,genres: mangaGenres[index][0]);
                                },
                              itemCount: 4,
                              controller: pageController,

                            ),
                          ),
                          const SizedBox(height: 40,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 1
                                )
                              )
                            ),
                            padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Explore CANVAS Now!",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                    Text("Your new favorite story is waiting", style: TextStyle(fontSize: 14),)
                                  ],
                                ),
                                GestureDetector(
                                  child: Text("See all",style: TextStyle(fontSize: 14,color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6)),),
                                )
                              ],
                          
                            ),
                          ),
                          Column(
                            children: state.allManga.keys.skip(2).take(7).map((genre) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          genre,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios,size: 14,)
                                      ],
                                    ),
                                  ),
                                  MyCarousel(mangas: state.allManga[genre]!, height: 150),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 50,),
                          const Expanded(child: Footer())
                        ]
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
      
              },
            ),
          ),
        ],
      ),
    );
  }
}


class TopM extends StatelessWidget {
  const TopM({super.key, required this.manga, required this.genres});
  final List<Manga> manga;
  final String genres;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Top " + genres,style: const TextStyle(fontSize: 18)),
                const Icon(Icons.arrow_forward_ios,size: 14,)
              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              context.read<DetailMangaBloc>().add(FetchDetailManga(manga[0].id));
              context.pushNamed("Detail_Manga",pathParameters: {'id':manga[0].id});
            },
            child: Container(
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
                              mangaThumb: manga[0].thumb,
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
                          Text(manga[0].title,
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
                          Text(manga[0].summary,
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
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap:(){
                      context.read<DetailMangaBloc>().add(FetchDetailManga(manga[index+1].id));
                      context.pushNamed("Detail_Manga",pathParameters: {'id':manga[index+1].id});
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Text("${index+2}",style: const TextStyle(
                            fontSize: 24,
                          ),),
                          const SizedBox(width: 16,),
                          CachedImage(mangaThumb: manga[index+1].thumb, height: 80, width: 80),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(manga[index+1].title,
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
      ),
    );
  }
}

class Recommend extends StatelessWidget {
  const Recommend({super.key, required this.manga});
  final List<Manga> manga;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
          child: Row(
            children: [
              const Text("Top picks for ",style: TextStyle(fontSize: 20),),
              Text("Phat Le",style: TextStyle(color:Theme.of(context).colorScheme.primary,fontSize: 20),)
            ],
          ),
        ),
        Container(
          height:250,
          width: double.maxFinite,
          child: PageView(
            children: [
               ListRecommend(manga: manga, char: 0),
               ListRecommend(manga: manga, char: 3),
               ListRecommend(manga: manga, char: 6),
            ],
          ),
        )
      ],
    );
  }
}

class ListRecommend extends StatelessWidget {
  const ListRecommend({super.key, required this.manga, required this.char});
  final List<Manga> manga;
  final int char;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return(
            ListTile(
              onTap: ()
              { context.read<DetailMangaBloc>().add(FetchDetailManga(manga[index].id));
              context.pushNamed("Detail_Manga",pathParameters: {'id':manga[index].id});
              },
              leadingAndTrailingTextStyle: const TextStyle(
                fontSize: 150
              ),
              leading: CachedImage(mangaThumb: manga[index+char].thumb,width: 75,height:200,),
              title: Text(manga[index+char].title,maxLines: 1,overflow: TextOverflow.ellipsis),
              subtitle: Text((Random().nextInt(99-93+1)+93).toString()+"% Match",style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),),
            )
          );
        },
    );
  }
}



