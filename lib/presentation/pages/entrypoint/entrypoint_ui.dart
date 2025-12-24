import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:leave_management/core/constants/app_defaults.dart';
import 'package:leave_management/presentation/pages/dashboard/dashboard.dart';
import 'package:leave_management/presentation/pages/profile/profile_screen.dart';

import 'components/app_navigation_bar.dart';

/// This page will contain all the bottom navigation tabs
class EntryPointUI extends StatefulWidget {
  const EntryPointUI({super.key});

  @override
  State<EntryPointUI> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends State<EntryPointUI> {
  /// Current Page
  int currentIndex = 1;

  /// On labelLarge navigation tap
  void onBottomNavigationTap(int index) {
    currentIndex = index;
    setState(() {});
  }

  /// All the pages
  List<Widget> pages = [
    const SizedBox(), LeaveDashboard(),
    ProfileScreen(),
    // const MenuPage(),
    // const CartPage(isHomePage: true),
    // const SavePage(isHomePage: false),
    // const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        duration: AppDefaults.duration,
        child: pages[currentIndex],
      ),

      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,

        onNavTap: onBottomNavigationTap,
      ),
    );
  }
}
