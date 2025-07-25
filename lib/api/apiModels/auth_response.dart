import 'package:pose_detection/Utility/parsing_types.dart';
import 'package:pose_detection/api/apiModels/user.dart';

class AuthResponse {
  final User user;
  final String? token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: SafeParser.toStringVal(json['token']),
    );
  }
  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
  }
}
