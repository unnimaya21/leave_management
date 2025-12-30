import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
import 'package:leave_management/presentation/providers/leave_provider.dart';

class LeaveController {
  final WidgetRef ref;
  final BuildContext context;

  LeaveController(this.ref, this.context);

  Future<void> updateRequestStatus(LeaveRequest request, String status) async {
    try {
      // 1. Show Loading Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 2. Prepare the request
      request.update = true;
      request.status = status;

      // 3. Call Repository
      await ref.read(leaveRepositoryProvider).updateLeaveRequest(request);

      // 4. Invalidate Providers (This replaces your manual setState)
      // This tells Riverpod to re-fetch data for the Dashboard automatically
      ref.invalidate(leaveRequestsProvider);
      ref.invalidate(leaveBalancesProvider);

      // 5. Close Dialogs and Show Success
      if (context.mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Leave $status successfully")));
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Close loading on error
      debugPrint("Update Error: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }
}
