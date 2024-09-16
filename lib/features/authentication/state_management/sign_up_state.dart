import '../models/sign_up_response.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SignupResponseModel response;

  SignUpSuccess(this.response);
}

class SignUpError extends SignUpState {
  final String errorMessage;

  SignUpError(this.errorMessage);
}

