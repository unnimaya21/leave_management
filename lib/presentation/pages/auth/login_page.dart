import 'package:flutter/material.dart';
import 'package:leave_management/core/constants/app_defaults.dart';
import 'package:leave_management/presentation/components/dont_have_account_row.dart';
import 'package:leave_management/presentation/components/login_header.dart';
import 'package:leave_management/presentation/components/login_page_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginPageHeader(),
                LoginPageForm(),
                SizedBox(height: AppDefaults.padding),
                DontHaveAccountRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
