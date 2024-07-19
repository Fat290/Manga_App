
import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/post.dart';
import 'package:doan_cs3/repositories/post_service.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'post_form.dart';
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if(response.error == null){
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
      context.pushReplacementNamed("Login")
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }


  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null){
      retrievePosts();
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
    }
  }



  // post like dislik
  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if(response.error == null){
      retrievePosts();
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
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? const Center(child:CircularProgressIndicator()) :
    RefreshIndicator(
      onRefresh: () {
        return retrievePosts();
      },
      child: ListView.builder(
          itemCount: _postList.length,
          itemBuilder: (BuildContext context, int index){
            Post post = _postList[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                  image: post.user!.avatar != null ?
                                  DecorationImage(image: NetworkImage('${post.user!.avatar}')) : null,
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.amber
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              '${post.user!.name}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17
                              ),
                            )
                          ],
                        ),
                      ),
                      post.user!.userId == userId ?
                      PopupMenuButton(
                        child: const Padding(
                            padding: EdgeInsets.only(right:10),
                            child: Icon(Icons.more_vert, color: Colors.white,)
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit'
                          ),
                          const PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete'
                          )
                        ],
                        onSelected: (val){
                          if(val == 'edit'){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostForm(
                              post: post,
                            )));
                          } else {
                            _handleDeletePost(post.id ?? 0);
                          }
                        },
                      ) : const SizedBox()
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Text('${post.body}'),
                  post.image != null ?
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${post.image}'),
                            fit: BoxFit.cover
                        )
                    ),
                  ) : SizedBox(height: post.image != null ? 0 : 10,),
                  Row(
                    children: [
                      kLikeAndComment(
                          post.likesCount ?? 0,
                          post.selfLiked == true ? Icons.favorite : Icons.favorite_outline,
                          post.selfLiked == true ? Colors.red : Colors.black54,
                              (){
                            _handlePostLikeDislike(post.id ?? 0);
                          }
                      ),
                      Container(
                        height: 25,
                        width: 0.5,
                        color: Colors.black38,
                      ),
                      kLikeAndComment(
                          post.commentsCount ?? 0,
                          Icons.sms_outlined,
                          Colors.black54,
                              (){
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(
                            //   postId: post.id,
                            // )));
                          }
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Colors.black26,
                  ),
                ],
              ),
            );
          }
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