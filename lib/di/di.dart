import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:leave_management/core/constants/storage_constants.dart';
import 'package:leave_management/core/constants/string_constants.dart';
import 'package:leave_management/core/services/error_service.dart'
    show ErrorService;
import 'package:leave_management/core/utils/shared_pref_service.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl, // Ensure this is set to your API's base URL
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Change InterceptorsWrapper to QueuedInterceptorsWrapper
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(StorageConstants.appToken);

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        print('====== Request Headers: ${options.headers}');
        return handler.next(options);
      },
      onError: (error, handler) async {
        String message = "Something went wrong!";

        if (error.response != null) {
          message = error.response?.data['message'] ?? error.message ?? message;
        } else {
          message = error.message!;
        }

        if (error.response?.statusCode == 401) {
          print(
            '----------------------- Unauthorized Error -----------------------',
          );
          // Unauthorized error, clear token and navigate to login
          final sharedPrefService = SharedPrefService();
          await sharedPrefService.remove(StorageConstants.appToken);
          await sharedPrefService.remove(StorageConstants.userKey);

          // Navigate to login screen using GetX
          Get.offAllNamed(AppRoutes.login);
        }

        ErrorService.showError(message);
        return handler.next(error);
      },
    ),
  );
  dio.interceptors.add(
    LogInterceptor(
      responseBody: true,
      error: true,
      requestHeader: true,
      request: true,
      requestBody: true,
      responseHeader: true,
    ),
  );
  return dio;
});
