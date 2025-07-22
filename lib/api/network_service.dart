import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pose_detection/API/apiModels/app_response.dart';
import 'package:pose_detection/Constants/app_api_constants.dart';
import 'package:pose_detection/Constants/app_string.dart' show AppStrings;
import 'package:pose_detection/main.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../Components/progress_dialog_utils.dart';

class NetworkService {
  static const int requestTimeOut = 60;
  late Dio dio;

  NetworkService() {
    dio = (Dio(_baseOptions));
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger());
    }
  }

  // ===================== BaseOptions
  final BaseOptions _baseOptions = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: requestTimeOut),
    receiveTimeout: const Duration(seconds: requestTimeOut),
    responseType: ResponseType.json,
    followRedirects: true,
  );

  // ===================== GET
  Future<AppResponse> get({
    String? url,
    Map<String, dynamic>? parameters,
    Function(int, int)? onReceiveProgress,
    ResponseType? responseType,
    bool showProgressBar = false,
  }) async {
    return await _safeFetch(
      showProgressBar,
      () async => dio.get(
        url!,
        queryParameters: parameters,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          validateStatus: (_) => true,
          headers: await headersRequest(),
          responseType: responseType,
        ),
      ),
    );
  }

  // ===================== POST
  Future<AppResponse> post({
    String? url,
    dynamic data,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
    ResponseType? responseType,
    bool showProgressBar = false,
  }) async {
    if (kDebugMode) {
      print("TAG_Request ${data.toString()}");
    }
    return await _safeFetch(
      showProgressBar,
      () async => dio.post(
        url!,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: Options(
          validateStatus: (_) => true,
          headers: await headersRequest(),
          responseType: responseType,
        ),
      ),
    );
  }
 // ===================== put
   Future<AppResponse> put({
    String? url,
    dynamic data,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
    ResponseType? responseType,
    bool showProgressBar = false,
  }) async {
    if (kDebugMode) {
      print("TAG_Request ${data.toString()}");
    }
    return await _safeFetch(
      showProgressBar,
      () async => dio.put(
        url!,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: Options(
          validateStatus: (_) => true,
          headers: await headersRequest(),
          responseType: responseType,
        ),
      ),
    );
  }

  Future<AppResponse> postWithMultipartFormData({
    String? url,
    dynamic data,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
    ResponseType? responseType,
    bool showProgressBar = false,
  }) async {
    if (kDebugMode) {
      print("TAG_Request ${data.toString()}");
    }
    return await _safeFetch(
      showProgressBar,
      () async => dio.post(
        url!,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: Options(
          validateStatus: (_) => true,
          headers: await headersRequest(),
          responseType: responseType,
        ),
      ),
    );
  }

  // ===================== DELETE
  Future<AppResponse> delete({
    String? url,
    dynamic data,
    Function(int, int)? onReceiveProgress,
    Function(int, int)? onSendProgress,
    ResponseType? responseType,
    bool showProgressBar = false,
  }) async {
    return await _safeFetch(
      showProgressBar,
      () async => dio.delete(
        url!,
        data: data,
        options: Options(
          validateStatus: (_) => true,
          responseType: responseType,
          headers: await headersRequest(),
        ),
      ),
    );
  }

  // ===================== SAFE FETCH
  Future<AppResponse> _safeFetch(
    bool showProgress,
    Future<Response> Function() tryFetch,
  ) async {
    try {
      if (showProgress) {
        ProgressDialogUtils.showProgressDialog();
      }
      final response = await tryFetch();
      return AppResponse.fromJson(response.data);
    } on FormatException catch (_) {
      throw AppStrings.msgNetworkErr;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw AppStrings.msgConnectInternet;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        if (kDebugMode) {
          print("error 211 ${e.type}");
          print("error 211 ${e.message}");
          print("error 211 ${e.error}");
        }
        throw AppStrings.msgConnectionTimeOut;
      } else if (e.type == DioExceptionType.cancel) {
        throw AppStrings.msgCanceled;
      }

      if (kDebugMode) {
        print("error ${e.toString()}");
        print("error 2 $e");
        print("CATCH error out side");
      }
      throw AppStrings.msgSomethingWentWrong;
    } on SocketException catch (e) {
      if (kDebugMode) {
        print("SocketException \n${e.toString()}");
      }
      throw AppStrings.msgConnectInternet;
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  // ===================== HANDLE EXCEPTION
  dynamic handleException(dynamic response) {
    if ((response as AppResponse).statusCode == 200) {
      if (kDebugMode) {
        print("statusCode == 200");
      }
      return response;
    } else if ((response).statusCode == 422) {
      response.message = response.message.toString();
      return response;
    } else {
      return response;
    }
  }

  Future<Map<String, dynamic>> headersRequest() async {
    String? token = secureStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
      // 'Accept-Language': selectedLanguage
      // 'Authorization':"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzg3OGUzN2Q3MTI4ZWU2OGFhMzVlNTU3NWYzMWIyOWFlMDNlNmI0OGUyOWU4ZjM5NTA0NjdjZWQ4MDI4NzI2Y2I5YTg5ZWY1NjMzZTZhNjYiLCJpYXQiOjE2NjYyNzE3MzUuNzQyNjc3LCJuYmYiOjE2NjYyNzE3MzUuNzQyNjgsImV4cCI6MTY5NzgwNzczNS43MjgzMTgsInN1YiI6Ijk3Iiwic2NvcGVzIjpbXX0.i0r394I-tXuT4AG7qbdWaI1WHNPdQQRgHGfxbOf2XVWHKa5nDl7lKgaVVMkpCnG44sjv1vVQ_Mu8iGXC_lTHiQBRJAfrdfSFu03MXINNjeufhsUw7RkTeAyFRlfHVeyiTawHiBsgXMeJ72HPKGPgK4wnCPHPxjdPWytdVhnAfFEtmOkf5O2W0gOHVJup-p-ChQDTZ5cYCvNUbtnWvUhfXEpz-Yje9J1lXMuzvyzV_RPopvt27pdc98fDAcaBBuP-Cpi6hLa4CHLEIBjTKfcWKkQcgwN5oPafZjWydnOEQSRr5FQsMRsC18SUuwb3Mts5JrPbdSummouNZ-9fFeHbqODVJCOXcNUt2Htn3dGRkKZF0gNGxmMG7p4XRQ_7OpLk4KeexmVOSL7v8fKBCKDixx1XiWrwoWRaHyYOPf5HNNsEWTHlWL9sAS0vPKSK5_v6ypMIUOtx7s059hb8ceagD5tMqz9rD73PURKUCyFXV9kDwna4lsv2rktE2oFVJbgUSuKf4Wbu1a0eesCQRmhsC3OSI9U--akcisQh5oNi1w_OljQQxIDDL7cGr2vslr8WrNbCUBBBEhSfTOcZrA_G8r_x9Wb2Z3FBYVXsNTUYCb_nrwtZ3riKQwG1aS9sqpnlzzIZM3a45DKh1jHFiE64_gN9urQgMojqiVua-TfOktQ"
    };
  }

  Future<Response> postRaw({
    required String url,
    required Map<String, dynamic> data,
    bool showProgressBar = true,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("NetworkService Exception: $e");
      }
      rethrow;
    }
  }
}
