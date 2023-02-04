import 'package:awesome_music/services/api/models/user.dart';
import 'package:awesome_music/services/local_storage_service/local_storage_service.dart';

class UserLocalStorageAdapter extends User implements LocalStorageSerializer {
  UserLocalStorageAdapter({required super.name, required super.email});

  factory UserLocalStorageAdapter.fromUser(User user) {
    return UserLocalStorageAdapter(email: user.email, name: user.name);
  }

  @override
  Map<String, dynamic> serialize() {
    return {'name': name, 'email': email};
  }

  static LocalStorageDeSerializer<User> get deserializer {
    return _UserLocalStorageDeserializer();
  }
}

class _UserLocalStorageDeserializer implements LocalStorageDeSerializer<User> {
  @override
  User deserialize(Map<String, dynamic> object) {
    return User(name: object['name'], email: object['email']);
  }
}
