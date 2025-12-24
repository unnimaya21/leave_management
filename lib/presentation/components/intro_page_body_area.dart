import 'package:flutter/material.dart';
import 'package:leave_management/routes/app_routes.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';

class IntroPageBodyArea extends StatelessWidget {
  const IntroPageBodyArea({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(flex: 5),
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              children: [
                Text(
                  'Welcome to',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Leave Management',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDefaults.padding * 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                    child: const Text('Login with Email'),
                  ),
                ),
                const SizedBox(height: AppDefaults.padding),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.signup),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Create an account'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
