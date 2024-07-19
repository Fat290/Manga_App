import 'dart:convert';
import 'package:doan_cs3/models/api_response.dart';
import 'package:doan_cs3/models/managa_fav.dart';
import 'package:doan_cs3/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String _localUrl = '10.0.2.2:8000';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final Uri uri = Uri.http(_localUrl, '/api/login');
    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    switch (response.statusCode) {
      case 200:
        final jsonData = json.decode(response.body);
        apiResponse.data = User.fromJson(jsonData);
        print( jsonData);
        break;
      case 422:
        final errors = json.decode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        print(errors);
        break;
      case 403:
        final errors = json.decode(response.body)['message'];
        apiResponse.error = errors;
        print(errors);
        break;
      default:
        apiResponse.error = "Something went wrong. Try again!";
    }
  } catch (e) {
    apiResponse.error = "Server error";
  }

  return apiResponse;
}

Future<ApiResponse> register(String name,String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try
  {
    final Uri uri = Uri.http(_localUrl, '/api/register');
    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password
      }),
    );

    switch(response.statusCode)
    {
      case 200:
        final jsonData = json.decode(response.body);
        apiResponse.data = User.fromJson(jsonData);
        break;
      case 422:
        final errors = json.decode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        final errors = json.decode(response.body)['message'];
        apiResponse.error = errors;
        break;
      default:
        apiResponse.error = "Something went wrong. Try again!";
    }
  }
  catch(e)
  {
    apiResponse.error = "Server error";
  }

  return apiResponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try
  {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/user');
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    );

    switch(response.statusCode)
    {
      case 200:
        final jsonData = json.decode(response.body);
        apiResponse.data = User.fromJson(jsonData);
        break;
      case 422:
        apiResponse.error = "Unauthorized.";
        break;
      default:
        apiResponse.error = "Something went wrong. Try again!";
    }
  }
  catch(e)
  {
    apiResponse.error = "Server error";
  }

  return apiResponse;
}

Future<ApiResponse> getListFavoriteManga() async {
  ApiResponse apiResponse = ApiResponse();
  try
  {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/mangas');
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    );

    switch(response.statusCode)
    {
      case 200:
        final jsonData = json.decode(response.body);
        final List<dynamic> mangaData = jsonData["mangas"];
        final listOfManga =
        mangaData.map<MangaFav>((json) => MangaFav.fromJson(json)).toList();
        apiResponse.data = listOfManga;
        break;
      case 422:
        apiResponse.error = "Unauthorized.";
        break;
      default:
        apiResponse.error = "Something went wrong. Try again!";
    }
  }
  catch(e)
  {
    apiResponse.error = "Server error";
  }

  return apiResponse;
}
//add manga to favorite
Future<ApiResponse> addMangaToList(String mangaId) async {
  ApiResponse apiResponse = ApiResponse();
  try
  {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/mangas');
    final response = await http.post(uri,
    headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
    },
    body: jsonEncode({
    'manga_id': mangaId
    }),
  );

    switch(response.statusCode)
    {
      case 200:
        final jsonData = json.decode(response.body);
        apiResponse.data = MangaFav.fromJson(jsonData);
        break;
      case 422:
        apiResponse.error = "Unauthorized.";
        break;
      default:
        apiResponse.error = "Something went wrong. Try again!";
    }
  }
  catch(e)
  {
    apiResponse.error = "Server error";
  }

  return apiResponse;
}

Future<String> getToken() async{
   SharedPreferences pref = await SharedPreferences.getInstance();
   return pref.getString('token')??'';
}

Future<int> getUserId() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId')??0;
}
Future<String> getUserName() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('userName')??"";
}
Future<bool> logout() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

Future<ApiResponse> updateUser(String name, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final Uri uri = Uri.http(_localUrl, '/api/user');
    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: image != null
          ? {
        'name': name,
        'avtar': image,
      }
          : {
        'name': name,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = json.decode(response.body)["message"];
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