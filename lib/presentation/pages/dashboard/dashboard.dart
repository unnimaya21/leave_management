import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/data/models/leave_category_model.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
import 'package:leave_management/presentation/pages/dashboard/components/balance_grid.dart';
import 'package:leave_management/presentation/pages/dashboard/components/dashboard_appbar.dart';
import 'package:leave_management/presentation/pages/dashboard/components/request_list.dart';
import 'package:leave_management/presentation/pages/leave/apply_leave.dart';
import 'package:leave_management/presentation/providers/auth_provider.dart';
import 'package:leave_management/presentation/providers/leave_provider.dart';

class LeaveDashboard extends ConsumerStatefulWidget {
  LeaveDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaveDashboardState();
}

class _LeaveDashboardState extends ConsumerState<LeaveDashboard> {
  List<LeaveRequest> requests = [];
  List<LeaveCategory> balances = [];
  int totalUsed = 0;
  int totalLeaves = 0;
  int totalPending = 0;

  @override
  void initState() {
    super.initState();
    // Fetch user and leave requests when the dashboard is initialized
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   _refreshDashboardData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final userAsync = ref.watch(userProvider);
    final requestsAsync = ref.watch(leaveRequestsProvider);
    final balancesAsync = ref.watch(leaveBalancesProvider);
    // Extract userRole from userAsync
    String userRole = '';
    if (userAsync is AsyncData && userAsync.value != null) {
      userRole = userAsync.value!.role ?? '';
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: dashBoardAppbar(userRole, requestsAsync),
      body: RefreshIndicator(
        onRefresh: () async {
          // Manual refresh logic
          ref.invalidate(leaveRequestsProvider);
          ref.invalidate(leaveBalancesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back, ${switch (userAsync) {
                  AsyncData(:final value) => value?.username ?? 'Guest',
                  _ => '...', // Shows dots while loading or on error
                }}!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: userRole != 'admin' ? 20 : 10),
              if (userRole != 'admin')
                // --- Leave Balances Grid ---
                // 2. Handle Balances Section
                balancesAsync.when(
                  data: (balances) => buildBalancesGrid(balances),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Text("Error loading balances: $e"),
                ),
              if (userRole != 'admin') const SizedBox(height: 30),
              const Text(
                "Recent Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // --- Recent Activity List ---
              requestsAsync.when(
                data: (requests) => buildRequestsList(requests, userRole, ref),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text("Error loading requests: $e"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: userRole != 'admin'
          ? FloatingActionButton.extended(
              onPressed: () => showApplyLeavePopup(context),
              label: const Text("Apply Leave"),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }

  showApplyLeavePopup(BuildContext context) async {
    // Capture the result of the dialog
    final success = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const ApplyLeaveScreen();
      },
    );

    // If successfully submitted, refresh the dashboard data
    if (success == true) {
      _refreshDashboardData();
    }
  }

  // Move your refresh logic into a reusable method
  Future<void> _refreshDashboardData() async {
    final updatedRequests = await ref
        .read(leaveRepositoryProvider)
        .getLeaveRequests();
    final updatedBalances = await ref
        .read(leaveRepositoryProvider)
        .getLeaveBalances();

    if (mounted) {
      setState(() {
        requests = updatedRequests;
        balances = updatedBalances;

        // Calculate totals using fold
        totalUsed = updatedBalances.fold(0, (sum, b) => sum + b.used);
        totalLeaves = updatedBalances.fold(0, (sum, b) => sum + b.total);
        totalPending = updatedBalances.fold(0, (sum, b) => sum + b.pending);
      });
    }
  }
}
