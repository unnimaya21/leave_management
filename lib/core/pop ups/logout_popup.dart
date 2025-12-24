import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/core/constants/storage_constants.dart';
import 'package:leave_management/core/utils/shared_pref_service.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';

void showLogoutPopup(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Confirm Logout"),
        content: const Text(
          "Are you sure you want to log out of Leave Management?",
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context), // Closes the popup
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          // Confirm Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Close the popup first
              _handleLogout(context, ref); // Execute logout logic
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );
}

Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
  final sharedPrefs = SharedPrefService();

  // 1. Remove all sensitive data from local storage
  await sharedPrefs.remove(StorageConstants.appToken);
  await sharedPrefs.remove(StorageConstants.userKey);

  // 2. Invalidate Providers to clear the cache in memory
  ref.invalidate(userProvider);
  ref.invalidate(authStateProvider);

  // 3. Navigate to Login and prevent going back
  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false, // This clears the entire navigation stack
    );
  }
}
