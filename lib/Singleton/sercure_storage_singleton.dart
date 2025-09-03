import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pose_detection/Constants/app_key.dart';
import 'package:pose_detection/api/apiModels/fitness_plan_response.dart';
import 'package:pose_detection/api/apiModels/fitness_tips_response.dart';
import 'package:pose_detection/api/apiModels/profile.dart';
import 'package:pose_detection/api/apiModels/user.dart';
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

  void storeToken(String token) {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    _prefs.setString(AppKey.keyToken, token);
  }

  String? getToken() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    return _prefs.getString(AppKey.keyToken);
  }

  void storeUserData(User user) {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String userObject = jsonEncode(user.toJson());
    _prefs.setString(AppKey.keyUserObject, userObject);
  }

  User? getUserData() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String? userDataJson = _prefs.getString(AppKey.keyUserObject);
    if (userDataJson == null) {
      if (kDebugMode) {
        print('No UserData found in SharedPreferences.');
      }
      return null;
    }
    try {
      final Map<String, dynamic> userDataMap = jsonDecode(userDataJson);
      return User.fromJson(userDataMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding LoginData: $e');
      }
      return null;
    }
  }

  void storeProfileData(Profile profile) {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String profileObject = jsonEncode(profile.toJson());
    _prefs.setString(AppKey.keyProfileObject, profileObject);
  }

  Profile? getProfileData() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String? profileDataJson = _prefs.getString(AppKey.keyProfileObject);
    if (profileDataJson == null) {
      if (kDebugMode) {
        print('No ProfileData found in SharedPreferences.');
      }
      return null;
    }
    try {
      final Map<String, dynamic> profileDataMap = jsonDecode(profileDataJson);
      return Profile.fromJson(profileDataMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding LoginData: $e');
      }
      return null;
    }
  }

  void storeFitnessTips(FitnessTipsResponse tips) {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String fitnessTipsData = jsonEncode(tips.toJson());
    _prefs.setString(AppKey.keyFitnessTips, fitnessTipsData);
  }

  FitnessTipsResponse? getFitnessTips() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String? fitnessTipsData = _prefs.getString(AppKey.keyFitnessTips);
    if (fitnessTipsData == null) {
      if (kDebugMode) {
        print('No FitnessTips in SharedPreferences.');
      }
      return null;
    }
    try {
      final Map<String, dynamic> fitnessTipsDataMap = jsonDecode(
        fitnessTipsData,
      );
      return FitnessTipsResponse.fromJson(fitnessTipsDataMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding FitnessTips: $e');
      }
      return null;
    }
  }

  void storeFitnessPlan(FitnessPlanResponse fitnessPlan) {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String fitnessPlanData = jsonEncode(fitnessPlan.toJson());
    _prefs.setString(AppKey.keyFitnessPlan, fitnessPlanData);
  }

   FitnessPlanResponse? getFitnessPlan() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final String? fitnessPlanData = _prefs.getString(AppKey.keyFitnessPlan);
    if (fitnessPlanData == null) {
      if (kDebugMode) {
        print('No FitnessPlan found in SharedPreferences.');
      }
      return null;
    }
    try {
      final Map<String, dynamic> fitnessPlanDataMap = jsonDecode(
        fitnessPlanData,
      );
      return FitnessPlanResponse.fromJson(fitnessPlanDataMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding FitnessPlan: $e');
      }
      return null;
    }
  }

  Future<void> storeBurnCalories(double calories) async {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }

    final profile = getProfileData();
    if (profile != null) {
      final updatedProfile = profile.copyWith(caloriesStatus: calories);

      await _prefs.setString(
        AppKey.keyProfileObject,
        jsonEncode(updatedProfile.toJson()),
      );

      if (kDebugMode) {
        print("Burned calories updated → $calories");
      }
    } else {
      if (kDebugMode) {
        print("No profile found. Cannot store burned calories.");
      }
    }
  }

  double? getBurnCalories() {
    if (!_initialized) {
      throw Exception("SecureStorageSingleton not initialized.");
    }
    final profile = getProfileData();
    return profile?.caloriesStatus;
  }
}
