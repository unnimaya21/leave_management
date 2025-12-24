import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leave_management/core/constants/app_icons.dart';

class AppBackButton extends StatelessWidget {
  /// Custom Back labelLarge with a custom ICON for this app
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(AppIcons.arrowBackward),
      onPressed: () => Navigator.pop(context),
    );
  }
}
