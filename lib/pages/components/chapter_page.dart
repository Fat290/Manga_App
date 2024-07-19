import 'package:doan_cs3/bloc/chapter/chapter_bloc.dart';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChapterPage extends StatelessWidget {
  const ChapterPage({super.key, required this.chapters, required this.manga});
  final Manga manga;
  final List<Chapter> chapters;
  @override
  Widget build(BuildContext context) {
    return Container(
     margin: EdgeInsets.only(left: 4,right: 4,top:16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.background,
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        //     spreadRadius: 5,
        //     blurRadius: 10,
        //     offset: Offset(0, 4),
        //   )
        // ]
      ),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
          padding:const EdgeInsets.all(12),
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  width: 2
                ),
              ),
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              child: ListTile(
               title: Text(chapters[index].title),
                leading: CachedImage(mangaThumb: manga.thumb,height:100, width:100),
                tileColor: Colors.transparent,
                contentPadding: const EdgeInsets.all(16),
                onTap: (){
                   context.read<ChapterBloc>().add(FetchChapterId(chapters[index].id));
                   context.pushNamed("ReadPage",pathParameters: {'chapterId':chapters[index].id,"id":chapters[index].mangaId});
                },
              ),
            );
          },
      ),
    );
  }
}
