import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/user.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
 void _loginUser() async{
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if(response.error == null)
      {
        print(response.data);
         _saveAndDirectToHome(response.data as User);
      }
    else{
      // print(response.data);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
 }
 void _saveAndDirectToHome(User user) async
 {
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
                "Hey,\nWelcome\nBack",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fade(duration: 1000.ms),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 140.0, top: 200.0),
            child: Container(
              height: 250.0,
              width: 250.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/login.gif'), // Path to your image
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
            padding: const EdgeInsets.only(top: 420.0),
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
                      // Gmail
                      SizedBox(
                        width: 350.0,
                        child: TextFormField(
                          style: TextStyle(color: Theme.of(context).colorScheme.background),
                          controller: txtEmail,
                          validator: (val)=> val!.isEmpty||!val.contains('@')?'Invalid email address!':null,
                          decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.mail, color: Colors.grey),
                            label: const Text(
                              'Gmail',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffB81736),
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
                          controller: txtPassword,
                          obscureText: _obscureText,
                          validator: (val)=>val!.length<6?'Require at least 6 character':null,
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
                                color: Color(0xffB81736),
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
                      // Align
                      const SizedBox(
                        width: 350.0,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90.0),
                      // Button
                      GestureDetector(
                        onTap: ()
                        {
                          if(formKey.currentState!.validate())
                          {
                            _loginUser();

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
                              'SIGN IN',
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
                            context.goNamed("SignUp");
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Do not have account?',
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
