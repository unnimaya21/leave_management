import 'package:flutter/material.dart';
import 'package:leave_management/core/constants/app_icons.dart';

import 'bottom_app_bar_item.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  final int currentIndex;
  final void Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      // color: const Color.fromARGB(255, 82, 80, 80),
      elevation: 0,
      height: 50,
      surfaceTintColor: Colors.transparent,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,

        children: [
          BottomAppBarItem(
            name: 'Recipes',
            iconLocation: AppIcons.menu,
            isActive: currentIndex == 0,
            onTap: () => onNavTap(0),
          ),
          BottomAppBarItem(
            name: 'Home',
            iconLocation: AppIcons.home,
            isActive: currentIndex == 1,
            onTap: () => onNavTap(1),
          ),

          BottomAppBarItem(
            name: 'Settings',
            iconLocation: AppIcons.profileSetting,
            isActive: currentIndex == 2,
            onTap: () => onNavTap(2),
          ),
        ],
      ),
    );
  }
}
