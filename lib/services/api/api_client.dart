import 'dart:convert';

import 'package:awesome_music/services/api/models/music.dart';
import 'package:awesome_music/services/api/models/user.dart';
import 'package:awesome_music/services/api/models/user_local_storage_adapter.dart';
import 'package:awesome_music/services/local_storage_service/local_storage_service.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final baseHostUrl = "http://localhost:8080";
  final _localStorageUserKey = 'user';
  final LocalStorageService _localStorageService;
  var client = http.Client();

  ApiClient({required LocalStorageService localStorageService})
      : _localStorageService = localStorageService;

  Future<User?> fetchAuthenticatedUser() async {
    try {
      return await _localStorageService.load<User>(
          _localStorageUserKey, UserLocalStorageAdapter.deserializer);
    } catch (_) {
      return null;
    }
  }

  Future<User> authenticate(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    final user = User(name: 'teste', email: email);
    _localStorageService
        .save(_localStorageUserKey, UserLocalStorageAdapter.fromUser(user))
        .then((value) => null)
        .catchError((_) {});
    return user;
  }

  Future<List<Music>> fetchMusics() async {
    final response = await client.get(Uri.parse("$baseHostUrl/musicas"));
    var decodedResponse =
        (jsonDecode(response.body) as List).map((e) => Map.from(e)).toList();
    await Future.delayed(const Duration(seconds: 2));
    return decodedResponse.map((e) => Music.fromJson(e, baseHostUrl)).toList();
  }
}
