import 'package:doan_cs3/pages/components/ranking_genres.dart';
import 'package:doan_cs3/pages/explore_page.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});
  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with SingleTickerProviderStateMixin{
  late TabController tabController;
  @override
  void initState(){
    super.initState();
    tabController = TabController(length: mangaGenres.length, vsync: this);
  }
  @override
  void dispose()
  {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: (){},
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.search),
            ),
          )
        ],
        title: const Text("Ranking"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                physics:const BouncingScrollPhysics(),
                tabs: mangaGenres.map((genres){
                   return Tab(
                     text: genres[0],
                   );
                }).toList (),
              ),
              Divider(height: 1, color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2)),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
          children: mangaGenres.map((genres) {
            return RankingGenres(genres: genres[0]);
          }).toList()

      ) ,
    );
  }
}
