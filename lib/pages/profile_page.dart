
import 'dart:typed_data';

import 'dart:io';
import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/user.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  bool loading = true;
  User? user;
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  Future<void> getImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = new File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    }
    else if (response.error == 'Unauthorized') {
      logout().then((value) =>
      {
        context.pushReplacementNamed("Login")
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  void updateProfile() async {
    ApiResponse response = await updateUser(
        txtNameController.text, _imageFile?.path.toString());
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.data}')
      ));
    }
    else if (response.error == 'Unauthorized') {
      logout().then((value) =>
      {
        context.pushReplacementNamed("Login")
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }
    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery
          .of(context)
          .size;
      return Stack(
        children: [
          Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  color: Colors.black,
                  // padding: const EdgeInsets.all(100) ,
                  height: size.height,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: SizedBox(

                          child: GestureDetector(
                            onTap: () {
                              showDialog( // showDialog
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog( // Dialog thay vì AlertDialog để tùy chỉnh kích thước
                                    shape: RoundedRectangleBorder( // Bo góc hộp thoại
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Container( // Container bao bọc nội dung
                                      padding: const EdgeInsets.all(20.0),
                                      width: 600, // Chiều rộng tùy chỉnh
                                      height: 450, // Chiều cao tùy chỉnh
                                     child:  Padding(
                                       padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
                                       child: ListView(
                                         children: [
                                           Center(
                                               child:GestureDetector(
                                                 child: Container(
                                                   width: 110,
                                                   height: 110,
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(60),
                                                       image: _imageFile == null ? user!.avatar != null ? DecorationImage(
                                                           image: NetworkImage('${user!.avatar}'),
                                                           fit: BoxFit.cover
                                                       ) : null : DecorationImage(
                                                           image: FileImage(_imageFile ?? File('')),
                                                           fit: BoxFit.cover
                                                       ),
                                                       color: Colors.amber
                                                   ),
                                                 ),
                                                 onTap: (){
                                                   getImage();
                                                 },
                                               )
                                           ),
                                           const SizedBox(height: 20,),
                                           Form(
                                             key: formKey,
                                             child: TextFormField(
                                               decoration: kInputDecoration('Name'),
                                               controller: txtNameController,
                                               validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                                             ),
                                           ),
                                           const SizedBox(height: 20,),
                                           kTextButton('Update', (){
                                             if(formKey.currentState!.validate()){
                                               setState(() {
                                                 loading = true;
                                               });
                                               updateProfile();
                                             }
                                           })
                                         ],
                                       ),
                                     )
                                    ), // Container
                                  ); // Dialog
                                },
                              ); // showDialog
                            },
                            child: const Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFFDA0037),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          backgroundImage: user!.avatar != null
                              ? NetworkImage('${user!.avatar}')
                              : null,

                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFDA0037),
                            width: 3.0,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: const Color(0xFFDA0037).withOpacity(0.5),
                          //
                          //     blurRadius: 50,
                          //     offset: const Offset(0, 5), // changes position of shadow
                          //   ),
                          // ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(user!.name ?? "", style: const TextStyle(
                              color: Color(0xFFDA0037),
                              fontSize: 24,
                            ),),
                            // SizedBox(
                            //   height: 24.0,
                            //   child: Icon(Icons.verified,color: Colors.grey,),
                            // )
                          ],
                        ),
                      ),
                      Text(user!.email ?? "", style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),),

                    ],

                  ),

                ),

              )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 340.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme
                          .of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                      const Color.fromARGB(255, 224, 128, 71)
                    ]
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.white60,
                          //   width: 2.0,
                          // ),
                          color: Theme
                              .of(context)
                              .colorScheme
                              .inversePrimary,
                          borderRadius: BorderRadius.circular(40),
                          // gradient: const LinearGradient(colors: [
                          //   Colors.black,
                          //   Colors.transparent,
                          // ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed("Posts");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius: BorderRadius.circular(
                                                30)
                                        ),
                                        child: Icon(FontAwesomeIcons.forumbee,
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .inversePrimary, size: 30.0,)
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        DefaultTextStyle(
                                            style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .background,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            child: const Text('Forum')
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, color: Theme
                                    .of(context)
                                    .colorScheme
                                    .background
                                    .withOpacity(0.7), size: 24,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.white60,
                          //   width: 2.0,
                          // ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          // gradient: const LinearGradient(colors: [
                          //   Colors.black,
                          //   Colors.transparent,
                          // ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: (){
                              context.pushNamed("Favorite");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius: BorderRadius.circular(
                                                30)
                                        ),
                                        child: Icon(
                                          Icons.favorite_border, color: Theme
                                            .of(context)
                                            .colorScheme
                                            .inversePrimary, size: 30.0,)
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        DefaultTextStyle(
                                            style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .background,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            child: const Text('Favorite Manga')
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, color: Theme
                                    .of(context)
                                    .colorScheme
                                    .background
                                    .withOpacity(0.7), size: 24,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.white60,
                          //   width: 2.0,
                          // ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          // gradient: const LinearGradient(colors: [
                          //   Colors.black,
                          //   Colors.transparent,
                          // ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius: BorderRadius.circular(
                                              30)
                                      ),
                                      child: Icon(Icons.settings, color: Theme
                                          .of(context)
                                          .colorScheme
                                          .inversePrimary, size: 30.0,)
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DefaultTextStyle(
                                          style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .background,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          child: const Text('Settings')
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios, color: Theme
                                  .of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.7), size: 24,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.white60,
                          //   width: 2.0,
                          // ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          // gradient: const LinearGradient(colors: [
                          //   Colors.black,
                          //   Colors.transparent,
                          // ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              logout().then((value) {
                                context.pushNamed("Login");
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius: BorderRadius.circular(
                                                30)
                                        ),
                                        child: Icon(Icons.logout, color: Theme
                                            .of(context)
                                            .colorScheme
                                            .inversePrimary, size: 30.0,)
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        DefaultTextStyle(
                                            style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .background,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            child: const Text('Log Out')
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, color: Theme
                                    .of(context)
                                    .colorScheme
                                    .background
                                    .withOpacity(0.7), size: 24,)
                              ],
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
        ],
      );
    }
  }


  InputDecoration kInputDecoration(String label) {
    return InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black))
    );
  }


// button

  TextButton kTextButton(String label, Function onPressed){
    return TextButton(
      child: Text(label, style: const TextStyle(color: Colors.white),),
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
          padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 10))
      ),
      onPressed: () => onPressed(),
    );
  }