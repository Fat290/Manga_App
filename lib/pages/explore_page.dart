
import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/pages/components/genres_manga_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
List<List<dynamic>> mangaGenres = [
  ['Action', FontAwesomeIcons.crosshairs],
  ['Adventure',  FontAwesomeIcons.mountain],
  ['Comedy',  FontAwesomeIcons.faceSmile],
  ['Drama',  FontAwesomeIcons.masksTheater],
  ['Fantasy', FontAwesomeIcons.masksTheater],
  ['Horror', FontAwesomeIcons.ghost],
  ['Mystery', FontAwesomeIcons.userSecret],
  ['Romance', FontAwesomeIcons.heart],
  ['Sci fi', FontAwesomeIcons.flask],
  ['Slice of Life', FontAwesomeIcons.sun],
  ['Sports', FontAwesomeIcons.football],
  ['Supernatural', FontAwesomeIcons.redditAlien],
  ['Historical',  FontAwesomeIcons.landmark],
  ['Psychological',  FontAwesomeIcons.brain],
  ['Martial Arts',  FontAwesomeIcons.palette],
  ['Shounen',  FontAwesomeIcons.person],
  ['Shoujo', FontAwesomeIcons.personDress],
  ['Seinen',  FontAwesomeIcons.mars],
  ['Josei',  FontAwesomeIcons.venus],
  ['Harem',  FontAwesomeIcons.chessKing],
  ['Isekai', FontAwesomeIcons.earthAmericas]
];
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
       with SingleTickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState()
  {
    super.initState();
    tabController =TabController(length: mangaGenres.length, vsync: this);
    tabController.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    if (!tabController.indexIsChanging) {
      String currentGenre = mangaGenres[tabController.index][0];
      // context.read<MangaBloc>().add(FetchListMangaByGenres(currentGenre));
    }
    setState(() {

    });

  }
  @override
  void dispose() {
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MangaBloc, MangaState>(
    builder: (context, state) {
     return Scaffold(
       appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: ()=> context.push(context.namedLocation("Ranking")),
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.emoji_events_outlined),
            ),
          )
        ],

        title: const Text("Genres"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Column(
            children: [
              Divider(height: 1, color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2)),
              TabBar(
                 controller: tabController,
                 isScrollable: true,
                 tabAlignment: TabAlignment.start,
                 physics:const BouncingScrollPhysics(),
                 unselectedLabelColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
                 tabs: mangaGenres.map((geners) {
                   return Tab(
                     text: geners[0],
                   );
                 }).toList(),
              ),

            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: mangaGenres.map((genres) {
          return GenresMangaPage(genres: genres[0], tabController: tabController);
        }).toList()

      ),
    );
  },
);
  }
}
