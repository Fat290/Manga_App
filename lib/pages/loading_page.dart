import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/pages/components/loading_page.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
 void loadUserInfo() async
 {
   String token = await getToken();
   if(token == '' || token.isEmpty)
     {
       context.pushReplacementNamed("Login");
       // print(token);
     }
   else {
     ApiResponse response = await getUserDetail();
     if (response.error == null) {
       context.pushReplacementNamed("Home");
     }
     else if(response.error == 'Unauthorized.'){
       context.pushReplacementNamed("Login");
     }
     else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
       context.pushReplacementNamed("Login");
     }
   }
 }

 @override
  void initState() {
    loadUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const LoadingAnimation();
  }
}
