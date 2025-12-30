import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/core/constants/app_colors.dart';
import 'package:leave_management/core/utils/date_formats.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
import 'package:leave_management/presentation/pages/dashboard/components/show_request_details.dart';
import 'package:leave_management/presentation/pages/dashboard/components/status_chip.dart';

Widget buildRequestsList(
  List<LeaveRequest> requests,
  String userRole,
  WidgetRef ref,
) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: requests.length,
    itemBuilder: (context, index) {
      LeaveRequest request = requests[index];
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: Colors.transparent,
          onTap: () => showRequestDetails(request, userRole, context, ref),
          child: Card(
            // margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: request.leaveType == 'vacation'
                    ? Icon(Icons.beach_access, color: Colors.white)
                    : request.leaveType == 'sick'
                    ? Icon(Icons.local_hospital, color: Colors.white)
                    : request.leaveType == 'paid'
                    ? Icon(Icons.work, color: Colors.white)
                    : request.leaveType == 'unpaid'
                    ? Icon(Icons.money_off, color: Colors.white)
                    : Icon(Icons.event_note, color: Colors.white),
              ),
              title: Row(
                children: [
                  Text(request.leaveType!.toUpperCase()),
                  if (userRole == 'admin')
                    Text(
                      '- ${request.userId!.username!}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
              subtitle: Text(
                '${ddMMMFormat.format(request.startDate!)} to ${ddMMMFormat.format(request.endDate!)}',
              ),
              trailing: buildStatusChip(request.status!),
            ),
          ),
        ),
      );
    },
  );
}
