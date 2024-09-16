// lib/features/authentication/models/sign_up_response.dart
class SignUpResponse {
  final int statusCode;
  final String message;
  final UserData? data;

  SignUpResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String firstName;
  final String lastName;
  final String email;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}
