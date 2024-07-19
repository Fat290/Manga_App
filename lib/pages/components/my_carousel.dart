import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class MyCarousel extends StatefulWidget {

  const MyCarousel({super.key, required this.mangas, required this.height});
  final List<Manga> mangas;
  final double height;
  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  final CarouselController _carouselController =   CarouselController();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: CarouselSlider(
          options: CarouselOptions(
            height: widget.height+75,
            aspectRatio: 16/9,
            viewportFraction: 0.4,
            pageSnapping: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        carouselController: _carouselController,
        items: widget.mangas.map((manga) {
                 return Builder(
                     builder: (BuildContext context){
                       return Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: SingleChildScrollView(
                           child: GestureDetector(
                             onTap: (){
                               context.read<DetailMangaBloc>().add(FetchDetailManga(manga.id));
                               context.pushNamed("Detail_Manga",pathParameters: {'id':manga.id});
                             },
                             child: Column(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children:
                                 [
                                   SizedBox(
                                     height: widget.height,
                                     width: 250,
                                     child: ClipRRect(
                                       borderRadius: BorderRadius.circular(16),
                                       child: CachedNetworkImage(
                                         fit: BoxFit.cover,
                                         imageUrl: manga.thumb,
                                         placeholder: (context, url) => Shimmer.fromColors(
                                           baseColor: Colors.grey[300]!,
                                           highlightColor: Colors.grey[100]!,
                                           child: Container(
                                             color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                           ),
                                         ),
                                         errorWidget: (context, url, error) => Icon(Icons.error),
                                       ),
                                     ),
                                   ),
                                   SizedBox(height: 12,),
                                   Center(
                                       child: Text(
                                         manga.title,
                                         maxLines: 2,
                                         textAlign: TextAlign.center,
                                         overflow: TextOverflow.ellipsis,
                                         style:  TextStyle(
                                             fontSize: 16.0,
                                             fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.inversePrimary
                                         ),
                                       )
                                   ),

                                 ]
                             ),
                           ),
                         ),
                       );
                     }
                 );
        }).toList(),
      ),
    );
  }
}
