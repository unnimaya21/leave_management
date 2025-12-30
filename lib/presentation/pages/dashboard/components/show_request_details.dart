import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/core/utils/date_formats.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
import 'package:leave_management/presentation/pages/dashboard/controllers/leave_controller.dart';

void showRequestDetails(
  LeaveRequest request,
  String userRole,
  BuildContext context,
  WidgetRef ref,
) {
  final controller = LeaveController(ref, context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 40), // Space for the icon
            child: Text(
              "${request.leaveType![0].toUpperCase()}${request.leaveType!.substring(1)} Request",
            ),
          ),
          Positioned(
            right: -12, // Align to far right
            top: -12, // Align to far top
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          if (userRole == 'admin') Text("User: ${request.userId!.username}"),
          Text(
            "Duration: ${ddMMMFormat.format(request.startDate!)} - ${ddMMMFormat.format(request.endDate!)}",
          ),

          Text("Reason: ${request.reason}"),

          Text("Status: ${request.status!.toUpperCase()}"),
        ],
      ),
      actions: [
        if (request.status!.toLowerCase() == 'pending') ...[
          if (userRole == 'admin') ...[
            // --- REJECT BUTTON ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                controller.updateRequestStatus(request, 'rejected');
                Navigator.pop(context);
              },
              child: const Text("Reject"),
            ),

            // --- APPROVE BUTTON ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                controller.updateRequestStatus(request, 'approved');
                Navigator.pop(context);
              },
              child: const Text("Approve"),
            ),
          ] else ...[
            // --- WITHDRAW BUTTON (FOR EMPLOYEES) ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                controller.updateRequestStatus(request, 'withdrawn');
                Navigator.pop(context);
              },
              child: const Text("Withdraw Request"),
            ),
          ],
        ],
      ],
    ),
  );
}
