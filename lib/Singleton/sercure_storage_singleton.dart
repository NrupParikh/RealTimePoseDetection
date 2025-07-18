import 'package:pose_detection/Constants/app_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageSingleton {
  static final SecureStorageSingleton _instance =
      SecureStorageSingleton._internal();
  late SharedPreferences _prefs;
  bool _initialized = false; // Add an initialization flag

  factory SecureStorageSingleton() {
    return _instance;
  }
  SecureStorageSingleton._internal() {
    _initializeSync(); // Initialize synchronously in the constructor
  }

  void _initializeSync() async {
    // Perform initialization asynchronously, but mark as initialized
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  void clearSharedPreference() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    _prefs.clear();
  }

  void storeLoginStatus(bool isLoggedIn) {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    _prefs.setBool(AppKey.keyIsLoggedIn, isLoggedIn);
  }

  bool? getLoginStatus() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    return _prefs.getBool(AppKey.keyIsLoggedIn);
  }


    void storeUserDataSavedFlag(bool isSaved) {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    _prefs.setBool(AppKey.keyIsUserDataSaved, isSaved);
  }

  bool? isUserDataSaved() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    return _prefs.getBool(AppKey.keyIsUserDataSaved);
  }

}
