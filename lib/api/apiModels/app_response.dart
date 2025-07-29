class AppResponse {
  int result;
  int statusCode;
  dynamic message;
  dynamic data;

  AppResponse({
    this.result = 0,
    this.statusCode = 0,
    this.message = "",
    this.data, 
  });

  factory AppResponse.fromJson(Map<String, dynamic> json) {
    return AppResponse(
      result: json["result"] ?? 0,
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      data: json["data"],
    );
  }

  factory AppResponse.userFromJson(dynamic str) {
    return AppResponse.fromJson(
      str,
    ); 
  }
   @override
  String toString() {
    return 'AppResponse(result: $result, statusCode: $statusCode, message: $message)';
  }
}

