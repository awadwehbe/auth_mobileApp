import 'package:auth_app/features/authentication/state_management/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/response_model.dart';
import '../models/sign_up_request.dart';
import '../models/sign_up_response.dart';
import '../repositories/sign_up_repository.dart';

/// Cubit States for the Sign-Up process

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepository signUpRepository;
// constructor invoke the repository.
  SignUpCubit(this.signUpRepository) : super(SignUpInitial());

  Future<void> signUp({
  required String firstName,
  required String lastName,
  required String email,
  required String password,
  }) async {
  emit(SignUpLoading());

  try {
  final signUpRequest = SignupRequestModel(
  firstName: firstName,
  lastName: lastName,
  email: email,
  password: password,
  );

  final response = await signUpRepository.signUp(signUpRequest);

  emit(SignUpSuccess(response));
  } catch (e) {
  emit(SignUpError(e.toString()));
  }
  }
  }
