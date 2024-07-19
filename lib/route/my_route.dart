import 'package:doan_cs3/pages/authenticate/login_page.dart';
import 'package:doan_cs3/pages/authenticate/onboarding_page.dart';
import 'package:doan_cs3/pages/authenticate/singup_page.dart';
import 'package:doan_cs3/pages/components/chapter_page.dart';
import 'package:doan_cs3/pages/components/lastest_manga.dart';
import 'package:doan_cs3/pages/components/list_fav.dart';
import 'package:doan_cs3/pages/components/read_page.dart';
import 'package:doan_cs3/pages/detail_manga_page.dart';
import 'package:doan_cs3/pages/explore_page.dart';
import 'package:doan_cs3/pages/home_page.dart';
import 'package:doan_cs3/pages/loading_page.dart';
import 'package:doan_cs3/pages/main_wrapper.dart';
import 'package:doan_cs3/pages/post_form.dart';
import 'package:doan_cs3/pages/post_page.dart';
import 'package:doan_cs3/pages/profile_page.dart';
import 'package:doan_cs3/pages/ranking_page.dart';
import 'package:doan_cs3/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class MyRoute{
  MyRoute._();

  static String initR = '/loading';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorLogin = GlobalKey<NavigatorState>(debugLabel: 'shell Login');
  static final _rootNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shell Home');
  static final _rootNavigatorSearch = GlobalKey<NavigatorState>(debugLabel: 'shell Search');
  static final _rootNavigatorExplore = GlobalKey<NavigatorState>(debugLabel: 'shell Explore');
  static final _rootNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shell Profile');
  static final GoRouter router = GoRouter(
      initialLocation: initR,
      navigatorKey: _rootNavigatorKey,
      routes:<RouteBase>[
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return MainWrapper(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                 navigatorKey: _rootNavigatorHome,
                 routes: [
                    GoRoute(
                        path: '/',
                        name: 'Home',
                        builder: (context, state) => HomePage(
                          key: state.pageKey,
                        ),
                    )
                 ]
               ),
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorSearch,
                  routes: [
                    GoRoute(
                      path: '/search_page',
                      name: 'Search',
                      builder: (context, state) => SearchPage(
                        key: state.pageKey,
                      ),
                    )
                  ]
              ),
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorExplore,
                  routes: [
                    GoRoute(
                      path: '/explore',
                      name: 'Explore',
                      builder: (context, state) => ExplorePage(
                        key: state.pageKey,
                      ),

                    ),

                  ]
              ),
              StatefulShellBranch(
                  navigatorKey: _rootNavigatorProfile,
                  routes: [
                    GoRoute(
                      path: '/profile',
                      name: 'Profile',
                      builder: (context, state) => ProfilePage(
                        key: state.pageKey,
                      ),

                    ),

                  ]
              )
            ]
        ),

        GoRoute(
          path: '/ranking',
          name: 'Ranking',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => RankingPage(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/posts',
          name: 'Posts',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => PostScreen(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/post_form',
          name: 'PostForm',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => PostForm(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/login',
          name: 'Login',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => LoginPage(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/signup',
          name: 'SignUp',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => SignUpPage(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'Onboarding',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => OnboardingPage(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/loading',
          name: 'Loading',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => LoadingPage(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/latest',
          name: 'Latest',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => LatestManga(
            key: state.pageKey,
          ),
        ),
        GoRoute(
          path: '/favorite',
          name: 'Favorite',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => ListFavPage(
            key: state.pageKey,
          ),
        ),
        GoRoute(
            path: "/detail_manga/:id",
            name: 'Detail_Manga',
            builder: (context, state) => DetailMangaPage(
                id: state.pathParameters["id"]!,
                key: state.pageKey,
            ),
            routes: [
              GoRoute(
                path: 'chapter/:chapterId',
                name: 'ReadPage',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => ReadPage(
                  chapterId: state.pathParameters["chapterId"]!,
                  key: state.pageKey,
                ),
              ),
            ]
        ),
        // GoRoute(
        //   path: '/detail_manga/:id',
        //   name: 'Detail_Manga',
        //   parentNavigatorKey: _rootNavigatorKey,
        //   builder: (context, state) => DetailMangaPage(
        //     id: state.pathParameters["id"]!,
        //     key: state.pageKey,
        //   ),
        // ),

        // GoRoute(
        //   path: '/detail_manga/:id/chapter/:ch',
        //   name: 'Detail_Manga',
        //   parentNavigatorKey: _rootNavigatorKey,
        //   builder: (context, state) => DetailMangaPage(
        //     id: state.pathParameters["id"]!,
        //     key: state.pageKey,
        //   ),
        // ),
      ],

  );
}
