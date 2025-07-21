import 'package:pose_detection/Utility/parsing_types.dart';

class User {
  final int id;
  final String? name;
  final String email;
  bool isProfileDataAvailable;

  User({
    required this.id,
    this.name,
    required this.email,
    required this.isProfileDataAvailable,
  });

  // Setter method for isProfileDataAvailable
  set profileDataAvailable(bool value) {
    isProfileDataAvailable = value;
  }

  // Getter method (optional, but good practice if you have a custom setter)
  bool get profileDataAvailable => isProfileDataAvailable;


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: SafeParser.toStringVal(
        json['name'],
      ),
      email: json['email'],
      isProfileDataAvailable: json['isProfileDataAvailable'] ?? false, // Added null-check with default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isProfileDataAvailable': isProfileDataAvailable,
    };
  }
}

