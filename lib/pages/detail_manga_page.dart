import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:doan_cs3/pages/components/chapter_page.dart';
import 'package:doan_cs3/pages/components/loading_page.dart';
import 'package:doan_cs3/pages/components/manga_information.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class DetailMangaPage extends StatefulWidget {
  const DetailMangaPage({super.key, required this.id});

  final String id;
  @override
  State<DetailMangaPage> createState() => _DetailMangaPageState();
}

class _DetailMangaPageState extends State<DetailMangaPage> with TickerProviderStateMixin {
  late final TabController tabController;
  ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics();
  late final ScrollController controller;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_handleTabSelection);
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.position.maxScrollExtent <= 0) {
        scrollPhysics = const NeverScrollableScrollPhysics();
      }
    });
    super.initState();
  }

  void _handleTabSelection() {
    if (!tabController.indexIsChanging) {
      // Handle tab selection changes if necessary
    }
    setState(() {});
  }


  @override
  void dispose() {
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailMangaBloc, DetailMangaState>(
        builder: (context, state) {
          if (state is LoadingDetailManga) {
            return const Center(child: LoadingAnimation());
          } else if (state is LoadDetailMangaFailure) {
            return const Center(child: Text('Failed to load mangas'));
          } else if (state is LoadedDetailManga) {
            if (state.detailManga == null) {
              return const Center(child: Text('No mangas found for this genre'));
            }
            final Manga mangaDetailInformation = state.detailManga.mangaInformation;
            final List<Chapter> mangaDetailChapter = state.detailManga.mangaChapters;
            return NestedScrollView(

              physics:scrollPhysics,
              controller: controller,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedImage(
                        mangaThumb: mangaDetailInformation.thumb,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(IconlyLight.arrow_left, size: 30, color: Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(48.0),
                      child: Column(
                        children: [
                        Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).colorScheme.background.withOpacity(0.8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                            width: 1,
                          ),
                        ),
                        child: TabBar(
                          controller: tabController,
                          labelColor: Theme.of(context).colorScheme.inversePrimary,
                          unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                          ),
                          tabs: [
                            const Tab(
                              child: Text("Information"),
                            ),
                            const Tab(
                              child: Text("Chapter"),
                            ),
                          ],
                        ),
                      )
                      ]
                    ),
                  ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.share_outlined, size: 30, color: Theme.of(context).colorScheme.secondary),
                          onPressed: () {},
                        ),
                      ],

                     ),
                   ];


              }, body: TabBarView(
              controller: tabController,
              physics: const BouncingScrollPhysics(), // Use BouncingScrollPhysics for smooth scrolling
              children: [
                MangaInformation(manga: mangaDetailInformation, chapter: mangaDetailChapter, tabController: tabController),
                ChapterPage(chapters: mangaDetailChapter, manga: mangaDetailInformation),
              ],
            ),
            );

          } else {
            return const Center(child: Text('Oops! Something went wrong!'));
          }
        },
      ),
    );
  }
}