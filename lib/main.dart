import 'package:doan_cs3/bloc/chapter/chapter_bloc.dart';
import 'package:doan_cs3/bloc/detail_manga/detail_manga_bloc.dart';
import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/bloc/search_manga/search_manga_bloc.dart';
import 'package:doan_cs3/route/my_route.dart';
import 'package:doan_cs3/themes/light_mode.dart';
import 'package:doan_cs3/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {
  static MangaBloc bloc = MangaBloc();
  @override
  bool get wantKeepAlive => true;
  // @override
  // void initState() {
  //    BlocProvider.of<MangaBloc>(context).add(FetchAllManga());
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MangaBloc>(
        lazy: false,
        create: (BuildContext context) => MangaBloc()..add(FetchAllManga())
        ),
        BlocProvider<DetailMangaBloc>(
            create: (context) => DetailMangaBloc(),
        ),
        BlocProvider<ChapterBloc>(
          create: (context) => ChapterBloc(),
        ),
        BlocProvider<SearchMangaBloc>(
          create: (context) => SearchMangaBloc(),
        ),
      ],
      // lazy: false,
      // create: (context) => MangaBloc(),
      child: MaterialApp.router(
        theme: darkMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        routerConfig: MyRoute.router,
      ),
    );
  }
}

