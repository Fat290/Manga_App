import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/user.dart';
import 'package:doan_cs3/pages/home_page.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool _obscureText = true;
  bool loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  void _registerUser() async{
    ApiResponse response = await register(nameController.text,mailController.text, passwordController.text);
    if(response.error == null)
    {
      print(response.data);
    _saveAndDirectToHome(response.data as User);
    }
    else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  // Save and redirect to home
  void _saveAndDirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token??'');
    await pref.setInt('userId', user.userId??0);
    await pref.setString("userName", user.name??"");
    context.pushReplacementNamed("Home");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffB81736),
                Color(0xffB81736),
              ]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 22),
              child: const Text(
                "Let's\nget started",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fade(duration: 1000.ms),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 140.0, top: 150.0),
            child: Container(
              height: 300.0,
              width: 300.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/signup.gif'), // Path to your image
                  fit: BoxFit.cover,
                  // colorFilter: ColorFilter.mode(
                  //   Colors.black54, // Adjust opacity as needed
                  //   BlendMode.dstATop,
                  // ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: SingleChildScrollView(

                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30.0),
                      //username
                      SizedBox(
                        width: 350.0,
                        child: TextFormField(
                          style: TextStyle(color: Theme.of(context).colorScheme.background),
                          controller: nameController,
                          decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.person, color: Colors.grey),
                            label: const Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF930728),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),

                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Type in your text",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      // Gmail
                      SizedBox(
                        width: 350.0,
                        child: TextFormField(
                          style: TextStyle(color: Theme.of(context).colorScheme.background),
                          validator: (val)=> val!.isEmpty||!val.contains('@')?'Invalid email address!':null,
                          controller: mailController,
                          decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.mail, color: Colors.grey),
                            label: const Text(
                              'Mail',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF930728),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Type in your text",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      // Password
                      SizedBox(
                        width: 350.0,
                        child: TextFormField(
                          style: TextStyle(color: Theme.of(context).colorScheme.background),
                          validator: (val)=>val!.length<6?'Require at least 6 character':null,
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            label: const Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF930728),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Type in your text",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // confirm
                      SizedBox(
                        width: 350.0,
                        child: TextFormField(
                          style: TextStyle(color: Theme.of(context).colorScheme.background),
                          validator: (val)=>passwordController.text != val?'Confirm password does not match!':null,
                          controller: passwordConfirmController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            label: const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF930728),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Type in your text",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 90.0),
                      // Button
                      loading ?
                      Center(child: CircularProgressIndicator()):
                      GestureDetector(
                        onTap: () {
                          if(formKey.currentState!.validate()){
                            setState(() {
                              loading = !loading;
                              _registerUser();
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(colors: [
                              Color(0xffB81736),
                              Color(0xffB81736),
                            ]),
                          ),
                          child: const Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Align
                      SizedBox(
                        child: GestureDetector(
                          onTap: () {
                           context.goNamed("Login");
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Have already account.',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
