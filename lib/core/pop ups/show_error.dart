import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void showErrorDialog(BuildContext context, dynamic error) {
  String message = "Something went wrong!";

  if (error is DioException) {
    if (error.response != null && error.response?.data != null) {
      // Custom message from API
      message = error.response?.data['message'] ?? message;
    } else {
      // Network or timeout error
      message = error.message ?? message;
    }
  } else if (error is String) {
    message = error;
  }

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
