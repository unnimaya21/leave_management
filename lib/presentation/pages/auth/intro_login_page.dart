import 'package:flutter/material.dart';
import 'package:leave_management/core/constants/app_images.dart';
import 'package:leave_management/presentation/components/intro_page_body_area.dart';

class IntroLoginPage extends StatelessWidget {
  const IntroLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(AppImages.introBackground1),
          IntroPageBodyArea(),
        ],
      ),
    );
  }
}
