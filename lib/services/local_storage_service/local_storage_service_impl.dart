part of 'local_storage_service.dart';

class _LocalStorageServiceImpl implements LocalStorageService {
  SharedPreferences? _prefs;

  FutureOr<SharedPreferences> get _instance async {
    return (_prefs ?? await SharedPreferences.getInstance());
  }

  @override
  Future<T> load<T>(String key, LocalStorageDeSerializer deserializer) async {
    final gottenJson = (await _instance).getString(key);
    if (gottenJson == null) {
      throw LocalStorageServiceNotFoundException();
    }
    final map = jsonDecode(gottenJson) as Map<String, dynamic>;
    return deserializer.deserialize(map);
  }

  @override
  Future<void> save(String key, LocalStorageSerializer serializer) async {
    final map = serializer.serialize();
    final wasSaved = await (await _instance).setString(key, jsonEncode(map));
    if (!wasSaved) {
      throw LocalStorageServiceException();
    }
  }
}
