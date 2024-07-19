import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Explore Comic"),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Explore Comic"),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Explore Comic"),
          )

        ],
      ),
    );
  }
}
