import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leave_management/core/pop%20ups/logout_popup.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the userProvider
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to Edit Profile Screen
              Navigator.pushNamed(context, AppRoutes.signup, arguments: 'edit');
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No user data found"));
          }
          print('User data in ProfileScreen: ${user.joinedDate}');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    user.username[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Username Display
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user.username),
                ),

                // Email Display
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(user.email),
                ),
                ListTile(
                  leading: const Icon(Icons.category_rounded),
                  title: Text(user.department),
                ),
                ListTile(
                  leading: const Icon(Icons.grade),
                  title: Text(user.designation),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(
                    DateFormat(
                      'dd-MM-yyyy',
                    ).format(DateTime.parse(user.joinedDate)),
                  ),
                ),

                const Divider(),

                // Logout Button
                ListTile(
                  onTap: () => showLogoutPopup(context, ref),
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
