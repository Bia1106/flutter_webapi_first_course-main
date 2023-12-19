import 'dart:convert';
import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';
import 'package:flutter_webapi_first_course/services/web_client.dart';
import 'package:http/http.dart' as http;

class JournalService {
  http.Client client = WebClient().client;
  String url = WebClient.url;
  static const String resource = 'journals/';

  String getUrl() {
    return '$url$resource';
  }

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(Uri.parse(getUrl()),
        headers: {
          'Content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonJournal);

    if (response.statusCode != 201) {
      if (response.body.contains('jwt expired')) {
        throw InvalidTokenException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool> update(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(Uri.parse("${getUrl()}$id"),
        headers: {
          'Content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonJournal);

    if (response.statusCode != 200) {
      if (response.body.contains('jwt expired')) {
        throw InvalidTokenException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    AuthService auth = AuthService();
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (response.body.contains('jwt expired')) {
        auth.deleteUserInfos();
        throw InvalidTokenException();
      }
      throw HttpException(response.body);
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    return list;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(
      Uri.parse("${getUrl()}$id"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      if (response.body.contains('jwt expired')) {
        throw InvalidTokenException();
      }
      throw HttpException(response.body);
    }
    return true;
  }
}
