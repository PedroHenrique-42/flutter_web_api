import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;
import '../models/journal.dart';

String url = WebClient.url;
http.Client client = WebClient().client;

class JournalService {
  static const String resource = "journals/";

  String getUrl() {
    return "$url$resource";
  }

  // Métodos HTTP

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );

    if (response.statusCode != 201) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    return true;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonJournal,
    );

    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    List<Journal> list = [];

    List<dynamic> jsonJournals = json.decode(response.body);

    for (var jsonMap in jsonJournals) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await client.delete(
      Uri.parse("${getUrl()}$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }
      throw HttpException(response.body);
    }

    return true;
  }
}

class TokenNotValidException implements Exception {}
