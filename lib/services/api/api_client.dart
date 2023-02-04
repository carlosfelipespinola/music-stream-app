import 'package:awesome_music/services/api/models/music.dart';
import 'package:awesome_music/services/api/models/user.dart';
import 'package:awesome_music/services/api/models/user_local_storage_adapter.dart';
import 'package:awesome_music/services/local_storage_service/local_storage_service.dart';

class ApiClient {
  final _localStorageUserKey = 'user';
  final LocalStorageService _localStorageService;

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
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(20, (index) {
      return Music(
          name: "Sinfonia n.º $index",
          audioUrl: "http://localhost:8080/music",
          imageUrl: "https://picsum.photos/id/${(index + 1) * 10}/200");
    });
  }
}
