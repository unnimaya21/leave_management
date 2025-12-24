import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leave_management/core/constants/app_defaults.dart';
import 'package:leave_management/core/constants/app_icons.dart';
import 'package:leave_management/core/themes/app_themes.dart';
import 'package:leave_management/core/utils/validators.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'login_button.dart';
import 'package:flutter/foundation.dart';

class LoginPageForm extends ConsumerStatefulWidget {
  const LoginPageForm({super.key});

  @override
  ConsumerState<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends ConsumerState<LoginPageForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isPasswordShown = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: kDebugMode ? 'lilly@gmail.com' : '',
    );
    passwordController = TextEditingController(
      text: kDebugMode ? 'Unnimaya' : '',
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onPassShowClicked() {
    setState(() {
      isPasswordShown = !isPasswordShown;
    });
  }

  Future<void> onLogin() async {
    final bool isFormOkay = _formKey.currentState?.validate() ?? false;
    if (isFormOkay) {
      try {
        // Use ref.read inside functions/callbacks
        final result = await ref.read(
          loginProvider({
            'email': emailController.text,
            'password': passwordController.text,
          }).future,
        );
        debugPrint('Login Successful: $result');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.entryPoint);
      } catch (e) {
        debugPrint('Login Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.defaultTheme.copyWith(
        inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email"),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: Validators.requiredWithFieldName('Email').call,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppDefaults.padding),

              const Text("Password"),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                onFieldSubmitted: (v) => onLogin(),
                textInputAction: TextInputAction.done,
                obscureText: !isPasswordShown,
                decoration: InputDecoration(
                  suffixIcon: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: onPassShowClicked,
                      icon: SvgPicture.asset(
                        isPasswordShown
                            ? AppIcons.eye
                            : AppIcons.eye, // Assuming you have an eyeOff icon
                        width: 24,
                      ),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: const Text('Forget Password?'),
                ),
              ),

              const SizedBox(height: AppDefaults.padding),

              LoginButton(
                onPressed: onLogin, // Pass the function reference here
              ),
            ],
          ),
        ),
      ),
    );
  }
}
