import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/data/models/leave_request_model.dart';

PreferredSizeWidget dashBoardAppbar(
  String userRole,
  AsyncValue<List<LeaveRequest>> requestsAsync,
) {
  return AppBar(
    title: const Text('Leave Dashboard', style: TextStyle(color: Colors.black)),
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      // --- Notification Icon with Badge for Admins ---
      if (userRole == 'admin')
        requestsAsync.when(
          data: (requests) => IconButton(
            icon: Badge.count(
              count: requests
                  .where((r) => r.status?.toLowerCase() == 'pending')
                  .length,
              child: const Icon(Icons.notifications),
            ),
            onPressed: () {},
          ),
          error: (e, st) => Text(e.toString()),
          loading: () => CircularProgressIndicator(),
        )
      else
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {},
        ),
    ],
  );
}
