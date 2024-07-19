import 'dart:convert';
import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/post.dart';
import 'package:doan_cs3/repositories/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Base URL
String _localUrl = '10.0.2.2:8000';

// Get all posts
Future<ApiResponse> getPosts() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/posts');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        final List posts = json.decode(response.body)['posts'];
        apiResponse.data = posts.map((p) => Post.fromJson(p)).toList();
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong, try again!';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error';
  }
  return apiResponse;
}

// Create post
Future<ApiResponse> createPost(String body, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/posts');
    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: image != null
          ? {
        'body': body,
        'image': image,
      }
          : {
        'body': body,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = json.decode(response.body);
        break;
      case 422:
        final errors = json.decode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong, try again!';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error';
  }
  return apiResponse;
}

// Edit post
Future<ApiResponse> editPost(int postId, String body) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/posts/$postId');
    final response = await http.put(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'body': body,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = json.decode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = json.decode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong, try again!';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error';
  }
  return apiResponse;
}

// Delete post
Future<ApiResponse> deletePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/posts/$postId');
    final response = await http.delete(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = json.decode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = json.decode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong, try again!';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error';
  }
  return apiResponse;
}

// Like or unlike post
Future<ApiResponse> likeUnlikePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/posts/$postId/likes');
    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = json.decode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong, try again!';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error';
  }
  return apiResponse;
}

// Helper functions
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}
