import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  http.Client client = WebClient().client;
  String url = WebClient.url;
  
  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse('${url}login'),
        body: {'email': email, 'password': password});
    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFoundException();
        case "Incorrect password":
          throw IncorrectPasswordException();
        default:
      }
      throw HttpException(response.body);
    }
    saveUserInfos(body: response.body);
    return true;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    http.Response response = await client.post(Uri.parse('${url}register'),
        body: {'email': email, 'password': password});
    if (response.statusCode != 201) {
      throw Exception();
    }
    saveUserInfos(body: response.body);
    return true;
  }

  saveUserInfos({required String body}) async {
    Map<String, dynamic> map = json.decode(body);
    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", token);
    prefs.setString("email", email);
    prefs.setInt("id", id);
  }

  deleteUserInfos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("accessToken");
    prefs.remove("id");
    prefs.remove("email");
  }
}

class IncorrectPasswordException implements Exception {}

class UserNotFoundException implements Exception {}

class InvalidTokenException implements Exception {}
