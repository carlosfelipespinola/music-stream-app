import 'package:awesome_music/services/api/models/user.dart';
import 'package:awesome_music/services/local_storage_service/local_storage_service.dart';

class UserLocalStorageAdapter extends User implements LocalStorageSerializer {
  UserLocalStorageAdapter({required super.token, required super.email});

  factory UserLocalStorageAdapter.fromUser(User user) {
    return UserLocalStorageAdapter(email: user.email, token: user.token);
  }

  @override
  Map<String, dynamic> serialize() {
    return {'name': token, 'email': email};
  }

  static LocalStorageDeSerializer<User> get deserializer {
    return _UserLocalStorageDeserializer();
  }
}

class _UserLocalStorageDeserializer implements LocalStorageDeSerializer<User> {
  @override
  User deserialize(Map<String, dynamic> object) {
    return User(token: object['name'], email: object['email']);
  }
}
