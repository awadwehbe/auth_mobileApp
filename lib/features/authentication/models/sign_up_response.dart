// lib/features/authentication/models/sign_up_response.dart
class SignupResponseModel {
  final int statusCode;
  final String message;
  final UserData? data;

  SignupResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
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
