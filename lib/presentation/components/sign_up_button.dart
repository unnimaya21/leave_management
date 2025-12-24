import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leave_management/core/constants/app_colors.dart';
import 'package:leave_management/core/constants/app_defaults.dart';
import 'package:leave_management/core/constants/app_icons.dart';

class SignUpButton extends ConsumerWidget {
  final VoidCallback? onPresssed;
  final bool? isFromEdit;
  const SignUpButton({super.key, this.onPresssed, this.isFromEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDefaults.padding * 2),
      child: Row(
        children: [
          Text(
            !isFromEdit! ? 'Sign Up' : 'Update',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onPresssed ?? () {},
            // style: ElevatedButton.styleFrom(elevation: 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: AppDefaults.borderRadius,
              ),
            ),
            child: SvgPicture.asset(
              AppIcons.arrowForward,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
