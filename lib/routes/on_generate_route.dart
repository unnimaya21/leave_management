import 'package:flutter/cupertino.dart';
import 'package:leave_management/presentation/pages/auth/intro_login_page.dart';
import 'package:leave_management/presentation/pages/auth/login_page.dart';
import 'package:leave_management/presentation/pages/auth/sign_up_page.dart';
import 'package:leave_management/presentation/pages/entrypoint/entrypoint_ui.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'package:leave_management/routes/unknown_page.dart';

class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;

    print('Navigating to route: ${settings.arguments}');

    switch (route) {
      case AppRoutes.introLogin:
        return CupertinoPageRoute(builder: (_) => const IntroLoginPage());

      // case AppRoutes.onboarding:
      //   return CupertinoPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.entryPoint:
        return CupertinoPageRoute(builder: (_) => const EntryPointUI());

      case AppRoutes.login:
        return CupertinoPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return CupertinoPageRoute(
          builder: (_) => SignUpPage(isFromEdit: settings.arguments == 'edit'),
        );

      // case AppRoutes.numberVerification:
      //   return CupertinoPageRoute(
      //       builder: (_) => const NumberVerificationPage());

      // case AppRoutes.forgotPassword:
      //   return CupertinoPageRoute(builder: (_) => const ForgetPasswordPage());

      // case AppRoutes.passwordReset:
      //   return CupertinoPageRoute(builder: (_) => const PasswordResetPage());

      // case AppRoutes.profile:
      //   return CupertinoPageRoute(builder: (_) => const ProfileScreen());

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
