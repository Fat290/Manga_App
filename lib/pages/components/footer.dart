import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.35,
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: 1,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondary
                )
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 24),
          child: Column(
            children: [
             const Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Notice",style: TextStyle(fontSize: 18)),
                     Text("Update to Ad Revenue Sharing Terms",style: TextStyle(fontSize: 12),)
                   ],
                 ),
                  Icon(Icons.arrow_forward_ios,size: 14,)
               ],
             ),
              SizedBox(height: 40,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.facebook),
                  FaIcon(FontAwesomeIcons.instagram),
                  FaIcon(FontAwesomeIcons.twitter),
                  FaIcon(FontAwesomeIcons.youtube),

                ],
              ),
              SizedBox(height: 24,),
              OutlinedButton(
                  onPressed: () {},
                  child: Text("Share MANGAVERSE",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8)),),
                  style:  OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    padding: EdgeInsets.all(14)
                  ),
              )
            ],
          ),
        )
    );
  }
}
