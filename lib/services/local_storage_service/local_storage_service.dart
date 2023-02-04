import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_service_exception.dart';
part 'local_storage_service_impl.dart';

abstract class LocalStorageSerializer {
  Map<String, dynamic> serialize();
}

abstract class LocalStorageDeSerializer<T> {
  T deserialize(Map<String, dynamic> object);
}

abstract class LocalStorageService {
  Future<void> save(String key, LocalStorageSerializer serializer);
  Future<T> load<T>(String key, LocalStorageDeSerializer<T> deserializer);

  factory LocalStorageService.create() {
    return _LocalStorageServiceImpl();
  }
}
