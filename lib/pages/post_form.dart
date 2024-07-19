import 'dart:convert';
import 'dart:io';

import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/post.dart';
import 'package:doan_cs3/pages/authenticate/login_page.dart';
import 'package:doan_cs3/repositories/post_service.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

class PostForm extends StatefulWidget {
  final Post? post;

 const PostForm({super.key,
    this.post,
  });

  @override
  State<PostForm> createState() => _PostFormState();


}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  String? getStringImage(File? imageFile) {
    if (imageFile == null) return null;
    final bytes = imageFile.readAsBytesSync();
    return base64Encode(bytes);
  }
  void _createPost() async {
    String? image = _imageFile ==  null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text, image);

    if(response.error ==  null) {
      context.pop();
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        context.pushReplacementNamed("Login")
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  // edit post
  void _editPost(int postId) async {
    ApiResponse response = await editPost(postId, _txtControllerBody.text);
    if (response.error == null) {
      Navigator.of(context).pop();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
      context.pushReplacementNamed("Login")
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    if(widget.post != null){
      _txtControllerBody.text = widget.post!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body:_loading ? const Center(child: CircularProgressIndicator(),) :  ListView(
        children: [
          widget.post != null ? const SizedBox() :
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
                image: _imageFile == null ? null : DecorationImage(
                    image: FileImage(_imageFile ?? File('')),
                    fit: BoxFit.cover
                )
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.image, size:50, color: Colors.black38),
                onPressed: (){
                  getImage();
                },
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _txtControllerBody,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                validator: (val) => val!.isEmpty ? 'Post body is required' : null,
                decoration: const InputDecoration(
                    hintText: "Post body...",
                    border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38))
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: kTextButton('Post', (){
              if (_formKey.currentState!.validate()){
                setState(() {
                  _loading = !_loading;
                });
                if (widget.post == null) {
                  _createPost();
                } else {
                  _editPost(widget.post!.id ?? 0);
                }
              }
            }),
          )
        ],
      ),
    );
  }
}

Expanded kLikeAndComment (int value, IconData icon, Color color, Function onTap) {
  return Expanded(
    child: Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color,),
              const SizedBox(width:4),
              Text('$value')
            ],
          ),
        ),
      ),
    ),
  );
}
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