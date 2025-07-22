import 'package:get/get.dart';
import 'package:pose_detection/Singleton/api_service_singleton.dart';
import 'package:pose_detection/api/api_service.dart';
import 'package:tuple/tuple.dart';

class ExerciseListController extends GetxController{
  final ApiService _apiService = ApiServiceSingleton().apiService;


  Future<Tuple2<bool, String?>> logout() async {
    try {
      var appResponse = await _apiService.logout();    
      if (appResponse.statusCode == 200) {
        return Tuple2(true, appResponse.message.toString());
      } else {
        return Tuple2(false, appResponse.message.toString());
      }
    } catch (ex) {
      return Tuple2(false, "$ex");
    }
  }
}