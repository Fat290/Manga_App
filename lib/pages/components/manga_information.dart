
import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/managa_fav.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/pages/components/my_avatars.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MangaInformation extends StatefulWidget {
  const MangaInformation({super.key, required this.manga, required this.chapter, required this.tabController});

  final Manga manga;
  final List<Chapter> chapter;
  final TabController tabController;

  @override
  State<MangaInformation> createState() => _MangaInformationState();
}

class _MangaInformationState extends State<MangaInformation> with AutomaticKeepAliveClientMixin{

  bool favState = false;
  @override
  bool get wantKeepAlive => true;
  void checkFavManga(String mangaId) async {
    ApiResponse response = await getListFavoriteManga();
    if (response.error == null) {
      bool isFav = false;
      List<MangaFav> favoriteMangas = response.data as List<MangaFav> ?? [];
      for (var manga in favoriteMangas) {
        if (manga.mangaId == mangaId) {
          isFav = true;
          break;
        }
      }
      setState(() {
        favState = isFav;
      });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(isFav ? 'This manga is already in your favorites' : 'This manga is not in your favorites'),
      // ));
    } else if (response.error == 'Unauthorized') {
      logout().then((value) => {
        context.pushReplacementNamed("Login")
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  void addFavorite(String mangaId) async {
    ApiResponse response = await addMangaToList(mangaId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Manga added to favorites')
      ));
    } else if (response.error == 'Unauthorized') {
      logout().then((value) => {
        context.pushReplacementNamed("Login")
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('')
      ));
    }
  }
  void toggleFavorite(String mangaId) {
    setState(() {
      favState = !favState;
    });
    if (favState == true) {
      addFavorite(mangaId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Removed from favorites!'),
      ));
    }
  }

  @override
  void initState() {
   checkFavManga(widget.manga.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 8,right: 8,top:16),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Theme.of(context).colorScheme.background,),
      padding: const EdgeInsets.only(top: 12),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.manga.title,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.manga.subTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.8)),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration:  BoxDecoration(
                    gradient:  LinearGradient(
                      colors: [
                      Theme.of(context).colorScheme.primary,
                        const Color.fromARGB(255, 152, 71, 60)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ElevatedButton(
                     onPressed: (){
                          toggleFavorite(widget.manga.id);
                     },
                     style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), // Bo góc của ElevatedButton
                      ),
                      backgroundColor: Colors.transparent,
                       shadowColor: Colors.transparent
                     ),
                     child: Icon(Icons.favorite,color: favState==false ? Theme.of(context).colorScheme.inversePrimary:Theme.of(context).colorScheme.primary,),

                               ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const MyBox(title: "Rating", subTitle: "4.5"),
                MyBox(title: "Chapter", subTitle: widget.chapter.length.toString()),
                const MyBox(title: "Language", subTitle: "ENG"),
              ],
            ),
            SizedBox(height: 40,),
            Container(
              child: Text(
                widget.manga.summary
              ),
            ),
            Row(

              children: [
                MyAvatar(),
                SizedBox(width: 12,),
                SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Author",textAlign: TextAlign.start,style: TextStyle(fontSize:12 ),),
                      Text("by "+ widget.manga.authors.first,textAlign: TextAlign.start,style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                SizedBox(width: 100,),
                Expanded(
                  child: ElevatedButton(
                      onPressed: (){
                             widget.tabController.animateTo(1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4)
                      ),

                      child: Text("Read Now",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


class MyBox extends StatelessWidget {
  const MyBox({super.key, required this.title, required this.subTitle});
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(4, 4),
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,),
            const SizedBox(height: 8,),
            Text(subTitle,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8)),),
          ],
        ),
      ),
    );
  }
}


