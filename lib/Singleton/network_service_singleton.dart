import 'package:pose_detection/api/network_service.dart';

class NetworkServiceSingleton {
  static final NetworkServiceSingleton _instance =
      NetworkServiceSingleton._internal();

  factory NetworkServiceSingleton() {
    return _instance;
  }

  NetworkServiceSingleton._internal() {
    _networkService = NetworkService();
  }

  late NetworkService _networkService;

  NetworkService get networkService => _networkService;
}
