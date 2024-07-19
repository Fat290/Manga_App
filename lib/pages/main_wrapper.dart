import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/pages/components/bottom_nav.dart';
import 'package:doan_cs3/pages/components/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;


  // void _goBranch(int index) {
  //   widget.navigationShell.goBranch(
  //     index,
  //     initialLocation: index == widget.navigationShell.currentIndex,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: widget.navigationShell,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNav(navigationShell: widget.navigationShell),

        ),
          BlocBuilder<MangaBloc,MangaState>(
              builder: (context, state) => state is LoadingAllManga?LoadingAnimation() : Container()
          )
      ]

      ),


    );
  }
}