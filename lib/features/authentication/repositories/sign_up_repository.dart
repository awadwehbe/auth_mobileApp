import '../../../core/network/api_client.dart';
import '../../../core/network/response_model.dart';
import '../models/sign_up_request.dart';
import '../models/sign_up_response.dart';

/// Repository class to handle all user-related API calls
class UserRepository {
  /// Sign-up method for registering a new user
  Future<SignUpRequest> signUp(SignUpRequest signupRequest) async {
    // Make the POST request using the ApiClient without token
    final response = await ApiClient.request(
      url: '/auth/signup', // API endpoint for sign-up
      method: 'POST',
      data: signupRequest.toJson(), // Convert the request model to JSON
      withToken: false, // No token required for signup


    );
    return response;
    // Parse the response using the ResponseModel and SignupResponseModel

  }
}