import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leave_management/core/constants/app_colors.dart';

class BottomAppBarItem extends StatelessWidget {
  const BottomAppBarItem({
    super.key,
    required this.iconLocation,
    required this.name,
    required this.isActive,
    required this.onTap,
  });

  final String iconLocation;
  final String name;
  final bool isActive;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconLocation,
        colorFilter: ColorFilter.mode(
          isActive ? AppColors.primary : AppColors.placeholder,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
