import 'package:doan_cs3/pages/explore_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MangaCategory extends StatelessWidget {
  const MangaCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left:20,right: 20,top: 20),
            child: Text("Favorite Genres",style: TextStyle(fontSize: 16),),
          ),
          Container(
            height: 700,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: mangaGenres.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Center(child: FaIcon(mangaGenres[index][1])) ,
                    ),
                    Text(mangaGenres[index][0])
                  ],
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 0,
                mainAxisSpacing: 4,
              ),
            ),
          )

        ],
      ),
    );
  }
}
