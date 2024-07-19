import 'package:cached_network_image/cached_network_image.dart';
import 'package:doan_cs3/bloc/chapter/chapter_bloc.dart';
import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/pages/components/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key, required this.chapterId});
  final String chapterId;

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> with AutomaticKeepAliveClientMixin {
  bool _showControls = true;
  int _currentChapterIndex = 0;
  List<Chapter> _chapters = [];
  @override
  bool get wantKeepAlive => true;
  void _currentIndex(){
  }
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }
  void _previousChapter() {
    if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
      });
      _loadChapter(_currentChapterIndex);
    }
  }

  void _nextChapter() {
    if (_currentChapterIndex < _chapters.length - 1) {
      setState(() {
        _currentChapterIndex++;
      });
      _loadChapter(_currentChapterIndex);
    }
  }

  void _loadChapter(int index) {
    final chapterId = _chapters[index].id;
    context.read<ChapterBloc>().add(FetchChapterId(chapterId));
    context.goNamed('ReadPage', pathParameters: {'chapterId': chapterId,'id':_chapters[index].mangaId});
  }
   static final customCacheManager = CacheManager(
      Config(
        'customCacheKey',
        stalePeriod: Duration(days: 1),
        maxNrOfCacheObjects: 100,

      )
   );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggleControls,
            child: BlocBuilder<ChapterBloc, ChapterState>(
              builder: (context, state) {
                if (state is LoadingChapter) {
                  return const Center(child: LoadingAnimation());
                } else if (state is LoadedChapterFailed) {
                  return const Center(child: Text('Failed to load chapters'));
                } else if (state is LoadedChapter) {
                  if (state.chapters == null) {
                    return const Center(child: Text('No chapters found for this genre'));
                  }
                  return ListView.builder(
                    itemCount: state.chapters.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(

                          child: CachedNetworkImage(
                            cacheManager: customCacheManager,
                            imageUrl: state.chapters[index].link,
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
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Oops! Something went wrong!'));
                }
              },
            ),
          ),
          if (_showControls) ...[
            BlocBuilder<DetailMangaBloc,DetailMangaState>(
                builder: (context, state) {
                  if(state is LoadedDetailManga){
                    if(state.detailManga.mangaChapters == null){
                      return const Center(child: Text('No chapters found for this genre'));
                    }
                    _chapters = state.detailManga.mangaChapters ??[];
                    _currentChapterIndex = _chapters.indexWhere((chapter) => chapter.id == widget.chapterId);
                     return Stack(

                       children: [
                         Positioned(
                           top:0,
                           left: 0,
                           right: 0,
                           child: Container(
                             height: 100,
                             decoration: BoxDecoration(
                                 color: Theme.of(context).colorScheme.background
                             ),
                             child:  Padding(
                               padding: const EdgeInsets.only(left: 14.0,right:14,top: 30),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(
                                     children: [
                                       IconButton(
                                         onPressed:(){
                                           context.pop();
                                         },
                                         icon:  const Icon(Icons.list,size: 36,),
                                       ),
                                       SizedBox(width: 12,),
                                       Text(_chapters[_currentChapterIndex].title,style: TextStyle(fontSize: 20),)
                                     ],
                                   ),
                                   IconButton(
                                     onPressed:(){
                                       context.pop();
                                     },
                                     icon: Icon(Icons.more_vert),
                                   )
                                 ],
                               ),
                             ),
                           ),
                         ),
                         Positioned(
                           bottom: 0,
                           left: 0,
                           right: 0,
                           child: Container(
                             decoration: BoxDecoration(
                                 color: Theme.of(context).colorScheme.background
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 const Row(
                                   children: [
                                     SizedBox(width: 10,),
                                     Icon(Icons.favorite_border),
                                     SizedBox(width: 4,),
                                     Text("3,988"),
                                     SizedBox(width: 12,),
                                     Icon(IconlyLight.chat),
                                     SizedBox(width: 4,),
                                     Text("72"),
                                   ],
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     IconButton(
                                       icon: Icon(IconlyBold.arrow_left_2),
                                       onPressed:
                                         _previousChapter
                                       ,
                                     ),
                                     IconButton(
                                       icon: Icon(IconlyBold.arrow_right_2),
                                       onPressed: _nextChapter
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         )
                       ],
                     );
                  }
                  else {
                    return const Center(child: Text('Oops! Something went wrong!'));
                  }
                },

            )
          ],
        ],
      ),
    );
  }
}
