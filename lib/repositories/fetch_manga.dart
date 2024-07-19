import 'dart:convert';
import 'package:doan_cs3/models/chapter.dart';
import 'package:doan_cs3/models/manga.dart';
import 'package:doan_cs3/models/page.dart';
import 'package:http/http.dart' as http;

String _apiKey = "469c25c1d9msh10cb51ff403a63ep108228jsnf5740d04913f";
String _apiHost = "mangaverse-api.p.rapidapi.com";
class MangaRepositories {
  Future<List<Manga>> fetchMangaData(String genres,String page) async {
    final Uri uri = Uri.https(_apiHost, '/manga/fetch', {
      'page': page,
      'genres': genres,
      'nsfw': 'true',
      'type': 'all',
    });

    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["code"] == 200) {
        final List<dynamic> mangaData = jsonData["data"];
        final listOfManga =
        mangaData.map<Manga>((json) => Manga.fromJson(json)).toList();
        return listOfManga;
      } else {
        throw Exception(
            "Failed to load Manga from server! Error code: ${jsonData["code"]}");
      }
    } else {
      throw Exception(
          "Failed to load Manga from server! HTTP status code: ${response.statusCode}");
    }
  }
//fetch latest
  Future<List<Manga>> fetchLatestManga() async
  {
    final Uri uri = Uri.https(_apiHost,'/manga/latest',{
      'page': '1',
      'genres': '',
      'nsfw': 'true',
      'type': 'all',
    });
    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["code"] == 200) {
        final List<dynamic> mangaData = jsonData["data"];
        final listOfLatestManga =
        mangaData.map<Manga>((json) => Manga.fromJson(json)).toList();
        return listOfLatestManga;
      } else {
        throw Exception(
            "Failed to load Manga from server! Error code: ${jsonData["code"]}");
      }
    } else {
      throw Exception(
          "Failed to load Manga from server! HTTP status code: ${response.statusCode}");
    }
  }
//search Manga
  Future<List<Manga>> searchManga(String title) async{
    final Uri uri = Uri.https(_apiHost,'/manga/search',{
      'text': title,
      'nsfw': 'true',
      'type': 'all',
    });
    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["code"] == 200) {
        final List<dynamic> mangaData = jsonData["data"];
        final listOfLatestManga =
        mangaData.map<Manga>((json) => Manga.fromJson(json)).toList();
        return listOfLatestManga;
      } else {
        throw Exception(
            "Failed to load Manga from server! Error code: ${jsonData["code"]}");
      }
    } else {
      throw Exception(
          "Failed to load Manga from server! HTTP status code: ${response.statusCode}");
    }
  }

  Future<Manga> fetchManga(String mangaId) async
  {
    final Uri uri = Uri.https(_apiHost,'/manga',{
       'id' : mangaId,
    });
    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["code"] == 200) {
        final mangaData = jsonData["data"];
        final Manga manga = Manga.fromJson(mangaData);
        return manga;
      } else {
        throw Exception(
            "Failed to load Manga from server! Error code: ${jsonData["code"]}");
      }
    } else {
      throw Exception(
          "Failed to load Manga from server! HTTP status code: ${response.statusCode}");
    }
  }

  Future<List<Chapter>> fetchChapter(String mangaId) async
  {
    final Uri uri = Uri.https(_apiHost,'/manga/chapter',{
      'id' : mangaId
    });
    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["code"] == 200) {
        final List<dynamic> mangaData = jsonData["data"];
        final listOfChapter =
        mangaData.map<Chapter>((json) => Chapter.fromJson(json)).toList();
        return listOfChapter;
      } else {
        throw Exception(
            "Failed to load Manga from server! Error code: ${jsonData["code"]}");
      }
    } else {
      throw Exception(
          "Failed to load Manga from server! HTTP status code: ${response.statusCode}");
    }
  }
// fetch image chapter
  Future<List<Page>> fetchImageChapter(String chapterId) async
  {
    final Uri uri = Uri.https(_apiHost,'/manga/image',{
      'id' : chapterId
    });
    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["code"] == 200) {
        final List<dynamic> mangaData = jsonData["data"];
        final listOfImage =
        mangaData.map<Page>((json) => Page.fromJson(json)).toList();
        return listOfImage;
      } else {
        throw Exception(
            "Failed to load Manga from server! Error code: ${jsonData["code"]}");
      }
    } else {
      throw Exception(
          "Failed to load Manga from server! HTTP status code: ${response.statusCode}");
    }
  }
}


