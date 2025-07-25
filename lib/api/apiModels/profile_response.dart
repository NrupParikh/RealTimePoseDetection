import 'package:pose_detection/api/apiModels/profile.dart';

class ProfileResponse {
  final Profile profile;

  ProfileResponse({required this.profile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),

    );
  }
  Map<String, dynamic> toJson() {
    return {'profile': profile.toJson()};
  }
}
