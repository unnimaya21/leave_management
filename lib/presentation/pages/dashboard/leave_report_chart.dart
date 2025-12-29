import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leave_management/data/models/leave_report_model.dart';
import 'package:leave_management/presentation/pages/dashboard/components/day_wise_report.dart';
import 'package:leave_management/presentation/providers/leave_provider.dart';

class LeaveReportChartPage extends ConsumerStatefulWidget {
  const LeaveReportChartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeaveReportChartPageState();
}

class _LeaveReportChartPageState extends ConsumerState<LeaveReportChartPage> {
  List<DailyLeaveReport> dalilyReports = [];

  @override
  void initState() {
    super.initState();
    // Fetch user and leave requests when the dashboard is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DateTime today = DateTime.now();
      String month = DateFormat('MMMM').format(today);
      String year = today.year.toString();
      dalilyReports = await ref
          .read(leaveRepositoryProvider)
          .getDayWiseLeaveReport(month, year);
      print("Fetched ${dalilyReports.length} bal requests.");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Attendance Report")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: LeaveReportChart(reports: dalilyReports),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: dalilyReports.length,
              itemBuilder: (context, index) {
                final report = dalilyReports[index];
                return ExpansionTile(
                  title: Text("Date: ${report.sId}"),
                  subtitle: Text("${report.totalLeaves} people on leave"),
                  children:
                      report.breakdown
                          ?.map(
                            (b) => ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(b.username ?? 'Unknown'),
                              subtitle: Text("${b.type}: ${b.reason}"),
                            ),
                          )
                          .toList() ??
                      [],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
