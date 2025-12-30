import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/presentation/pages/auth/intro_login_page.dart';
import 'package:leave_management/presentation/pages/entrypoint/entrypoint_ui.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';

class LeaveManagement extends ConsumerWidget {
  const LeaveManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text('Error loading token: $err'))),
      data: (token) {
        if (token.isEmpty) {
          return const IntroLoginPage();
        } else {
          // Force a fresh fetch of the user profile
          ref.invalidate(userProvider);
          return const EntryPointUI();
        }
      },
    );
  }
}
