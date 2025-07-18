class RegisterData {
  final int id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String token;

  RegisterData({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      id: json['id'] ?? 0,
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'token': token,
    };
  }
}