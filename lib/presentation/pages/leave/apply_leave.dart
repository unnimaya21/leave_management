import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leave_management/core/constants/app_colors.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
import 'package:leave_management/presentation/providers/leave_provider.dart';

class ApplyLeaveScreen extends ConsumerStatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  ConsumerState<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends ConsumerState<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Data
  String? selectedType;
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController _reasonController = TextEditingController();

  // Dropdown Options
  final List<String> leaveTypes = [
    "sick",
    "casual",
    "vacation",
    "paid",
    "other",
  ];

  // Helper to calculate days
  int get totalDays {
    if (startDate != null && endDate != null) {
      return endDate!.difference(startDate!).inDays + 1;
    }
    return 0;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    return Scaffold(
      appBar: AppBar(title: const Text("Apply for Leave")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Leave Type Dropdown ---
                const Text(
                  "Leave Type",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text("Select Leave Type"),
                  items: leaveTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type[0].toUpperCase() + type.substring(1),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => selectedType = val),
                  validator: (val) =>
                      val == null ? "Please select a type" : null,
                ),

                const SizedBox(height: 20),

                // --- Date Range Picker ---
                const Text(
                  "Duration",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDate == null
                              ? "Select Date Range"
                              : "${DateFormat('MMM d').format(startDate!)} - ${DateFormat('MMM d, y').format(endDate!)}",
                        ),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                  ),
                ),
                if (totalDays > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Total Days: $totalDays",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // --- Reason Field ---
                const Text(
                  "Reason for Leave",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Enter your reason here...",
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val!.isEmpty ? "Reason is required" : null,
                ),

                const SizedBox(height: 30),

                // --- Submit Button ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          startDate != null) {
                        // 1. Create your model
                        LeaveRequest leaveRequest = LeaveRequest(
                          leaveType: selectedType ?? '',
                          startDate: startDate!,
                          endDate: endDate!,
                          reason: _reasonController.text,
                          totalDays: totalDays,
                          status: 'pending',
                        );

                        // 2. Access the repository directly via ref.read
                        // This is the most "direct" way without a controller
                        final result = await ref
                            .read(leaveRepositoryProvider)
                            .newLeaveRequest(leaveRequest);

                        debugPrint("Success: $result");
                        ref.invalidate(leaveRequestsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Application Submitted Successfully!",
                              ),
                            ),
                          );
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    child: const Text(
                      "Submit Application",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
