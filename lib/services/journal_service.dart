import 'dart:convert';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';

class JournalService {
  static const String _url = "http://192.168.15.24:3000/";
  static const String _resource = "journals/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return "$_url$_resource";
  }

  // Métodos HTTP

  Future<bool> register(Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {"Content-type": "application/json"},
      body: jsonJournal,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> edit(String id, Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {"Content-type": "application/json"},
      body: jsonJournal,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getUrl()));

    if (response.statusCode != 200) {
      throw Exception();
    }

    List<Journal> list = [];

    List<dynamic> jsonJournals = json.decode(response.body);

    for (var jsonMap in jsonJournals) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> delete(String id) async {
    http.Response response = await client.delete(Uri.parse("${getUrl()}$id"));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
