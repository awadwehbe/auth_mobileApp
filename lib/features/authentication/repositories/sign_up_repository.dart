import '../../../core/error/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../models/sign_up_request.dart';
import '../models/sign_up_response.dart';

/// Sign-up method for registering a new user
class SignUpRepository {
  Future<SignupResponseModel> signUp(SignupRequestModel signUpRequest) async {
    try {
      final response = await ApiClient.request(
        url: '/auth/signup', // Your signup endpoint
        method: 'POST',
        data: signUpRequest.toJson(),
      );
      return SignupResponseModel.fromJson(response.data);
    } on AuthException catch (e) {
      throw AuthException(message: e.message); // Handle auth-specific exceptions
    } on ApiException catch (e) {
      throw ApiException(message: e.message); // Handle other API-related exceptions
    } catch (e) {
      throw GeneralException(message: 'An unknown error occurred during signup');
    }
  }
}
