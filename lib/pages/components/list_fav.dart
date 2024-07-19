import 'package:doan_cs3/bloc/manga/manga_bloc.dart';
import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/managa_fav.dart';
import 'package:doan_cs3/pages/components/cached_image.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListFavPage extends StatefulWidget {
  const ListFavPage({super.key});

  @override
  State<ListFavPage> createState() => _ListFavPageState();
}

class _ListFavPageState extends State<ListFavPage> {
  List<MangaFav> mangaFavList = [];

  void getList() async {
    ApiResponse response = await getListFavoriteManga();
    if (response.error == null) {
      mangaFavList = response.data as List<MangaFav>;
      print(mangaFavList[0].mangaId);
    } else if (response.error == 'Unauthorized') {
      logout().then((value) {
        Navigator.pushReplacementNamed(context, 'Login');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('List of favorite mangas loaded'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getList(); // Gọi hàm getList khi trang được khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Mangas'),
      ),
      body: BlocBuilder<MangaBloc, MangaState>(
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
              return ListView.builder(
                itemCount: mangaFavList.length,
                itemBuilder: (context, index) {
                  final favManga = mangaFavList[index];
                  final foundManga = state.allManga.values
                      .expand((list) => list)
                      .firstWhere((manga) => manga.id == favManga.mangaId);

                  print(mangaFavList[0].mangaId);
                  if (foundManga != null) {
                    return ListTile(
                      leading: CachedImage(mangaThumb: foundManga.thumb,height: 100,width: 100,),
                      title: Text(foundManga.title),
                      subtitle: Text(foundManga.authors.isNotEmpty ? foundManga.authors[0] : ''),
                      onTap: () {

                      },
                    );
                  } else {

                    return SizedBox.shrink();
                  }
                },
              );
            }
          } else {
            return Center(child: Text('Select a genre to view mangas'));
          }
        },
      ),
    );
  }
}
