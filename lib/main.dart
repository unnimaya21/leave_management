// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:leave_management/core/themes/app_themes.dart';
import 'package:leave_management/leave_management.dart';
import 'package:leave_management/di/app_binding.dart';
import 'package:leave_management/routes/on_generate_route.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.onGenerate,
      navigatorKey: navigatorKey,
      theme: AppTheme.defaultTheme,
      initialBinding: AppBinding(),
      home: const LeaveManagement(),
    );
  }
}
