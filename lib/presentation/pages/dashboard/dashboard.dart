import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/core/utils/date_formats.dart';
import 'package:leave_management/data/models/leave_category_model.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      requests = await ref.read(leaveRepositoryProvider).getLeaveRequests();
      balances = await ref.read(leaveRepositoryProvider).getLeaveBalances();

      for (var balance in balances) {
        totalUsed += balance.used;
        totalLeaves += balance.total;
        totalPending += balance.pending;
      }
      print("Fetched ${balances.length} bal requests.");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Leave Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          requests = await ref.read(leaveRepositoryProvider).getLeaveRequests();
          setState(() {});
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
              const SizedBox(height: 20),

              // // --- Leave Balance Grid ---
              // GridView.count(
              //   crossAxisCount: 2,
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   crossAxisSpacing: 16,
              //   mainAxisSpacing: 16,
              //   childAspectRatio: 1.5,
              //   children: [
              //     _buildStatCard("Annual Leave", "12", Colors.blue),
              //     _buildStatCard("Sick Leave", "05", Colors.orange),
              //     _buildStatCard("Casual Leave", "03", Colors.green),
              //     _buildStatCard("Used Total", "08", Colors.red),
              //   ],
              // ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemCount: balances.length + 1,
                itemBuilder: (context, index) {
                  if (index == balances.length) {
                    return _buildStatCard(
                      "Total Used",
                      '${totalUsed + totalPending}/$totalLeaves',
                      Colors.redAccent, // Distinct color for the total
                    );
                  }
                  final balance = balances[index];
                  return _buildStatCard(
                    '${balance.name[0].toUpperCase()}${balance.name.substring(1)} Leave', // Capitalize
                    '${balance.used + balance.pending}/${balance.available.toString()}',
                    _getCategoryColor(balance.name),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                "Recent Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // --- Recent Activity List ---
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  LeaveRequest request = requests[index];
                  return InkWell(
                    onTap: () => _showRequestDetails(request),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        title: Text(request.leaveType.toUpperCase()),
                        subtitle: Text(
                          '${ddMMMFormat.format(request.startDate)} to ${ddMMMFormat.format(request.endDate)}',
                        ),
                        trailing: _buildStatusChip(request.status),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showApplyLeavePopup(context),
        label: const Text("Apply Leave"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  showApplyLeavePopup(BuildContext context) {
    showDialog(
      context: context,
      // isScrollControlled: true,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      // ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.all(10),
          child: ApplyLeaveScreen(),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'withdrawn':
        color = Colors.grey;
        break;
      default:
        color = Colors.orange; // Pending
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showRequestDetails(LeaveRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("${request.leaveType.toUpperCase()} Request"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Duration: ${ddMMMFormat.format(request.startDate)} - ${ddMMMFormat.format(request.endDate)}",
            ),
            const SizedBox(height: 8),
            Text("Reason: ${request.reason}"),
            const SizedBox(height: 8),
            Text("Status: ${request.status.toUpperCase()}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          // ONLY SHOW WITHDRAW BUTTON IF PENDING
          if (request.status.toLowerCase() == 'pending')
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  _handleWithdraw(request.id!), // Pass the document/request ID
              child: const Text("Withdraw Request"),
            ),
        ],
      ),
    );
  }

  void _handleWithdraw(String requestId) async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call API (Ensure this method exists in your repository)
      await ref.read(leaveRepositoryProvider).withdrawLeaveRequest(requestId);

      if (mounted) {
        Navigator.pop(context); // Close loading
        Navigator.pop(context); // Close details dialog

        // Refresh the list locally
        final updatedRequests = await ref
            .read(leaveRepositoryProvider)
            .getLeaveRequests();
        setState(() {
          requests = updatedRequests;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Leave request withdrawn successfully")),
        );
        await ref.read(leaveRepositoryProvider).getLeaveBalances();
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("Withdraw Error: $e");
    }
  }

  Color _getCategoryColor(String name) {
    switch (name.toLowerCase()) {
      case 'annual':
        return Colors.blue;
      case 'sick':
        return Colors.orange;
      case 'casual':
        return Colors.green;
      case 'vacation':
        return Colors.purple;
      default:
        return Colors.red;
    }
  }
}
