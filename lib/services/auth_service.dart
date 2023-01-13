import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_interceptors.dart';

class AuthService {
  // TODO: Modularizar o endpoint
  static const String _url = "http://192.168.15.24:3000/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(
      Uri.parse("${_url}login"),
      body: {
        'email': email,
        'password': password
      }
    );

    if (response.statusCode != 200) {
      String content = jsonDecode(response.body);
      switch(content) {
        case "Cannot find user":
          throw UserNotFindException();
      }
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);

    return true;
  }

  Future<bool> register({required String email, required String password}) async {
    http.Response response = await client.post(
        Uri.parse("${_url}register"),
        body: {
          'email': email,
          'password': password
        }
    );

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);
    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = json.decode(body);

    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    print("$token\n$email\n$id");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", token);
    prefs.setString("email", email);
    prefs.setInt("id", id);

    String? tokenSalvo = prefs.getString("accessToken");
    print(tokenSalvo);
  }
}

class UserNotFindException implements Exception {
}