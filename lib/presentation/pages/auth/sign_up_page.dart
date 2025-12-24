import 'package:flutter/material.dart';
import 'package:leave_management/core/constants/app_colors.dart';
import 'package:leave_management/core/constants/app_defaults.dart';
import 'package:leave_management/presentation/components/sign_up_form.dart';
import 'package:leave_management/presentation/components/sign_up_page_header.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key, this.isFromEdit = false});
  final bool? isFromEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldWithBoxBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!isFromEdit!) SignUpPageHeader(),
                SizedBox(height: AppDefaults.padding),
                SignUpForm(isFromEdit: isFromEdit!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
