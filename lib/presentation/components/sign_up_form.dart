import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart'; // Add this for date formatting
import 'package:leave_management/core/constants/app_defaults.dart';
import 'package:leave_management/core/constants/app_icons.dart';
import 'package:leave_management/core/utils/date_formats.dart';
import 'package:leave_management/core/utils/validators.dart';
import 'package:leave_management/data/models/user_model.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';
import 'package:leave_management/routes/app_routes.dart';
import 'already_have_accout.dart';
import 'sign_up_button.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final bool isFromEdit;
  const SignUpForm({super.key, this.isFromEdit = false});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  final TextEditingController designation = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();

  String? selectedDepartment;
  User? existingUser;
  final List<String> departments = [
    "Development",
    "HR",
    "Sales",
    "Marketing",
    "Other",
  ];
  @override
  void initState() {
    super.initState();
    if (widget.isFromEdit) {
      existingUser = ref.read(userProvider).value;
      if (existingUser != null) {
        print(
          "Editing user: ${existingUser!.department}   ${existingUser!.department[0].toUpperCase() + existingUser!.department.substring(1)}",
        );
        userName.text = existingUser!.username;
        userEmail.text = existingUser!.email;
        designation.text = existingUser!.designation;
        joinDateController.text = ddmmYYYYFormat.format(
          DateTime.parse(existingUser!.joinedDate),
        );
        int deptIndex = departments.indexWhere(
          (dept) =>
              dept.toLowerCase() == existingUser!.department.toLowerCase(),
        );
        selectedDepartment = departments[deptIndex];

        print("Selected Department: $selectedDepartment $departments");
      } else {
        print("No existing user data found for editing.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDefaults.margin),
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Name"),
          TextFormField(
            controller: userName,
            validator: Validators.requiredWithFieldName('Name').call,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDefaults.padding),

          _buildLabel("Email"),
          TextFormField(
            controller: userEmail,
            validator: Validators.required.call,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDefaults.padding),

          // --- New Field: Department Dropdown ---
          _buildLabel("Department"),
          DropdownButtonFormField<String>(
            value: selectedDepartment,
            hint: const Text("Select Department"),
            items: departments.map((dept) {
              return DropdownMenuItem(value: dept, child: Text(dept));
            }).toList(),
            onChanged: (val) => setState(() => selectedDepartment = val),
            validator: (val) => val == null ? "Required" : null,
          ),
          const SizedBox(height: AppDefaults.padding),

          // --- New Field: Designation ---
          _buildLabel("Designation"),
          TextFormField(
            controller: designation,
            validator: Validators.required.call,

            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDefaults.padding),

          // --- New Field: Join Date Selector ---
          _buildLabel("Join Date"),
          TextFormField(
            controller: joinDateController,
            readOnly: true, // Prevents typing
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(pickedDate);
                setState(() => joinDateController.text = formattedDate);
              }
            },
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_today),
              hintText: "Select Date",
            ),
            validator: Validators.required.call,
          ),

          if (!widget.isFromEdit) ...[
            const SizedBox(height: AppDefaults.padding),
            _buildLabel("Password"),
            TextFormField(
              validator: Validators.required.call,
              controller: userPassword,
              obscureText: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.eye, width: 24),
                ),
              ),
            ),
          ],

          const SizedBox(height: AppDefaults.padding),
          SignUpButton(
            isFromEdit: widget.isFromEdit,
            onPresssed: () async {
              // Ensure you update your User Model to accept these new fields
              User user = User(
                username: userName.text,
                email: userEmail.text,
                password: userPassword.text,
                id: '',
                department: selectedDepartment!.toLowerCase(),
                designation: designation.text,
                joinedDate: joinDateController.text,
              );

              if (!widget.isFromEdit) {
                try {
                  // 1. Wait for Signup to finish
                  final result = await ref.read(signUpProvider(user).future);

                  if (result.email.isNotEmpty) {
                    // 2. IMPORTANT: Invalidate the provider
                    ref.invalidate(userProvider);

                    // 3. CRITICAL: Wait for the provider to actually fetch the new data
                    // from SharedPreferences before navigating
                    await ref.read(userProvider.future);

                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.entryPoint,
                        (route) =>
                            false, // This condition 'false' removes all previous routes
                      );
                    }
                  }
                } catch (e) {
                  debugPrint("Signup Error: $e");
                }
              } else {
                final result = await ref.read(updateUserProvider(user).future);

                if (result) {
                  // ignore: use_build_context_synchronously

                  Navigator.pop(context);
                }
              }
            },
          ),

          if (!widget.isFromEdit) const AlreadyHaveAnAccount(),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
