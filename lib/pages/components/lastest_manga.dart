import 'package:carousel_slider/carousel_slider.dart';
import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LatestManga extends StatefulWidget {
  const LatestManga({ Key? key }) : super(key: key);
  @override
  _LatestMangaState createState() => _LatestMangaState();
}

class _LatestMangaState extends State<LatestManga> {
  CarouselController _carouselController = new CarouselController();
  int _current = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MangaBloc, MangaState>(
    builder: (context, state) {
    return  BlocBuilder<MangaBloc, MangaState>(
      builder: (context, state) {
        if (state is LoadingAllManga) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadMangaFailure) {
          return Center(child: Text('Failed to load mangas'));
        } else if (state is LoadedAllManga) {
          if (state.allManga == null) {
            return Center(child: Text('No mangas found for this genre'));
          } else {
            // Hiển thị danh sách các truyện yêu thích
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    CachedImage(mangaThumb: state.allManga["Latest"]![_current].thumb, height: MediaQuery.of(context).size.height*0.6, width: MediaQuery.of(context).size.width),
                    // Positioned(
                    //     top: 40,
                    //     left: 20,
                    //     child:GestureDetector(
                    //         child: Icon(Icons.arrow_back,color:  Theme.of(context).colorScheme.secondary,size: 24,),
                    //       onTap: (){
                    //           context.pop();
                    //       },
                    //     )
                    // ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Theme.of(context).colorScheme.background.withOpacity(1),
                                  Theme.of(context).colorScheme.background.withOpacity(1),
                                  Theme.of(context).colorScheme.background.withOpacity(1),
                                  Theme.of(context).colorScheme.background.withOpacity(1),
                                  Theme.of(context).colorScheme.background.withOpacity(0),
                                  Theme.of(context).colorScheme.background.withOpacity(0),
                                  Theme.of(context).colorScheme.background.withOpacity(0),
                                  Theme.of(context).colorScheme.background.withOpacity(0),
                                ]
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 500.0,
                          aspectRatio: 16/9,
                          viewportFraction: 0.70,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        carouselController: _carouselController,

                        items:state.allManga["Latest"]!.map((manga) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color:  Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 320,
                                          margin: EdgeInsets.only(top: 30),
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: CachedImage(mangaThumb: manga.thumb,height: 250,width: 200,)
                                        ),
                                        SizedBox(height: 20),
                                        Text(manga.title, style:
                                        TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        // rating
                                        SizedBox(height: 12),
                                        Container(
                                          child: Text(manga.summary, style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey.shade600
                                          ), textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        AnimatedOpacity(
                                          duration: Duration(milliseconds: 500),
                                          opacity: _current == state.allManga["Latest"]!.indexOf(manga) ? 1.0 : 0.0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.star, color:   Theme.of(context).colorScheme.primary.withOpacity(0.8), size: 20,),
                                                      SizedBox(width: 5),
                                                      Text('4.5', style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.grey.shade600
                                                      ),)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.access_time, color: Colors.grey.shade600, size: 20,),
                                                      SizedBox(width: 5),
                                                      Text('2h', style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.grey.shade600
                                                      ),)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.play_circle_filled, color: Colors.grey.shade600, size: 20,),
                                                      SizedBox(width: 5),
                                                      Text('Read', style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.grey.shade600
                                                      ),)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              );
                            },
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(child: Text('Select a genre to view mangas'));
        }
      },
    );
  },
);
  }
}