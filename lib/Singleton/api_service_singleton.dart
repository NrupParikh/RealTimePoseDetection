


import 'package:pose_detection/api/api_service.dart';

import 'network_service_singleton.dart';

class ApiServiceSingleton {
  static final ApiServiceSingleton _instance = ApiServiceSingleton._internal();

  factory ApiServiceSingleton() {
    return _instance;
  }

  ApiServiceSingleton._internal() {
    _apiService = ApiService(NetworkServiceSingleton().networkService);
  }

  late ApiService _apiService;

  ApiService get apiService => _apiService;
}
