import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String dctSessionIdKey = 'dct_session_id';
const String dctIcfDocumentKey = 'icf_document';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal(); // singleton

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  void saveSessionToken(String value) async {
    await _secureStorage.write(key: dctSessionIdKey, value: value);
  }

  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: dctSessionIdKey);
  }
  //
  // void saveIcfDocument(String value) async {
  //   await _secureStorage.write(key: dctIcfDocumentKey, value: value);
  // }
  //
  // Future<String?> getIcfDocument() async {
  //   return await _secureStorage.read(key: dctIcfDocumentKey);
  // }

}