import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/response_model.dart';
import '../models/sign_up_request.dart';
import '../models/sign_up_response.dart';
import '../repositories/sign_up_repository.dart';

/// Cubit States for the Sign-Up process
abstract class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SignUpResponse user;

  SignUpSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);

  @override
  List<Object> get props => [message];
}

/// Cubit to handle the Sign-Up process
class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository userRepository;

  SignUpCubit(this.userRepository) : super(SignUpInitial());

  /// Function to initiate the sign-up process
  Future<void> signUp(String firstName, String lastName, String email, String password) async {
    emit(SignUpLoading()); // Emit loading state

    // Create sign-up request model
    SignUpRequest signupRequest = SignUpRequest(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    try {
      // Call the repository to handle the sign-up process
      ResponseModel<SignUpResponse> response = await userRepository.signUp(signUpRequest);

      if (response.statusCode == 200) {
        emit(SignUpSuccess(response.data!)); // Emit success state with user data
      } else {
        emit(SignUpError(response.message)); // Emit error state with message
      }
    } catch (e) {
      emit(SignUpError("An error occurred during sign-up.")); // Emit error state on exception
    }
  }
}
