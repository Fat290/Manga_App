import 'package:flutter/material.dart';

class MyAvatar extends StatelessWidget {
  const MyAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        // boxShadow:[
        //   BoxShadow(
        //   color: Colors.grey,
        //   blurRadius: 10,
        //   offset: Offset(0, 6),
        // )
        //   ],

      ),
      child: const CircleAvatar(
        radius: 30.0,
        backgroundImage:
        NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7ut5ImIGij7xxSShxWk-uyCJbjkIdLYpTWNJTJTFnPA&s'),
        backgroundColor: Colors.transparent,

      ),
    ) ;
  }
}
