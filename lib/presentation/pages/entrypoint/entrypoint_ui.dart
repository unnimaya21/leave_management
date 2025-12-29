import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/core/constants/app_defaults.dart';
import 'package:leave_management/presentation/pages/dashboard/dashboard.dart';
import 'package:leave_management/presentation/pages/dashboard/dashboard_graph_screen.dart';
import 'package:leave_management/presentation/pages/dashboard/leave_report_chart.dart';
import 'package:leave_management/presentation/pages/profile/profile_screen.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';

import 'components/app_navigation_bar.dart';

/// This page will contain all the bottom navigation tabs
class EntryPointUI extends ConsumerStatefulWidget {
  const EntryPointUI({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends ConsumerState<EntryPointUI> {
  /// Current Page
  int currentIndex = 1;

  /// On labelLarge navigation tap
  void onBottomNavigationTap(int index) {
    currentIndex = index;
    setState(() {});
  }

  String userRole = '';

  /// All the pages
  List<Widget> pages = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var user = ref.watch(userProvider);
      user.when(
        data: (data) => userRole = data!.role,
        error: (Object error, StackTrace stackTrace) {},
        loading: () {},
      );
      print('0000000 $user');

      pages = [
        userRole == 'admin'
            ? LeaveReportChartPage()
            : const DashBoardGraphScreen(),
        LeaveDashboard(),
        ProfileScreen(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        final String userRole = user?.role ?? 'employee';

        // 2. Define the pages list here based on the role
        final List<Widget> pages = [
          userRole == 'admin'
              ? const LeaveReportChartPage()
              : const DashBoardGraphScreen(),
          LeaveDashboard(),
          const ProfileScreen(),
        ];
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
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
