import 'package:dio/dio.dart';
import 'package:leave_management/core/constants/storage_constants.dart';
import 'package:leave_management/core/services/error_service.dart';
import 'package:leave_management/core/utils/shared_pref_service.dart';
import 'package:leave_management/data/models/user_model.dart';
import 'package:leave_management/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SharedPrefService _sharedPrefService = SharedPrefService();

  AuthRepositoryImpl(this._dio);
  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/auth/forgotPassword',
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Forgot password email sent successfully.');
        return true;
      } else {
        print(
          'Failed to send forgot password email. Status code: ${response.statusCode}',
        );
        return false;
      }
    } on DioException catch (error) {
      String message = "Something went wrong!";

      message = error.response?.data['message'] ?? error.message ?? message;
      ErrorService.showError(message);
      return false;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      print('=====response from signup: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token =
            response.data['token']; // Assuming the token is in the response

        // Store the token using SharedPrefService
        await _sharedPrefService.saveString(StorageConstants.appToken, token);
        await _sharedPrefService.saveUser(User.fromJson(response.data['user']));

        return User.fromJson(
          response.data['user'],
        ); // Adjust according to your API response structure
      } else {
        throw Exception('Failed to sign up: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      String message = "Something went wrong!";

      message = error.response?.data['message'] ?? error.message ?? message;
      ErrorService.showError(message);
      // Handle specific Dio errors (timeout, 404, etc.)
      throw Exception('Failed to sign up: ${error.message}');
    }
  }

  @override
  Future<User> signUp(User user) async {
    try {
      final response = await _dio.post('/auth/signup', data: user.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('=====response from signup: ${response.data}');
        final token =
            response.data['token']; // Assuming the token is in the response
        // Store the token using SharedPrefService
        await _sharedPrefService.saveString(StorageConstants.appToken, token);
        await _sharedPrefService.saveUser(User.fromJson(response.data['user']));

        return User.fromJson(response.data['user']);
      } else {
        throw Exception('Failed to sign up: ${response.statusMessage}');
      }
    } on DioException catch (error) {
      String message = "Something went wrong!";

      message = error.response?.data['message'] ?? error.message ?? message;
      ErrorService.showError(message);
      // Handle specific Dio errors (timeout, 404, etc.)
      throw Exception('Failed to sign up: ${error.message}');
    }
  }

  @override
  Future<bool> updateUser(User user) async {
    try {
      final response = await _dio.patch('/users/updateMe', data: user.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _sharedPrefService.remove(StorageConstants.userKey);
        User updatedUser = User.fromJson(response.data['data']['user']);
        await _sharedPrefService.saveUser(updatedUser);
        await _sharedPrefService.getUser().then((value) {
          print('Updated user from Shared Preferences: ${value?.toJson()}');
        });
        print('User updated successfully. ${(response.data['data']['user'])}');

        // await _sharedPrefService.saveUser(User.fromJson(response.data['user']));

        return true;
      } else {
        print('Failed to update user. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      String message = "Something went wrong!";
      message = error.toString();
      ErrorService.showError(message);
      return false;
    }
  }
}
