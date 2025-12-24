import 'package:flutter/material.dart';
import 'package:leave_management/core/constants/app_colors.dart';
import 'package:leave_management/core/constants/app_images.dart';

class LoginPageHeader extends StatelessWidget {
  const LoginPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.asset(AppImages.roundedLogo),
          ),
        ),

        Text(
          'Leave Management',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
