import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leave_management/data/models/leave_report_model.dart';
import 'package:leave_management/presentation/pages/dashboard/components/day_wise_report.dart';
import 'package:leave_management/presentation/providers/leave_provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class LeaveReportChartPage extends ConsumerStatefulWidget {
  const LeaveReportChartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeaveReportChartPageState();
}

class _LeaveReportChartPageState extends ConsumerState<LeaveReportChartPage> {
  List<DailyLeaveReport> dalilyReports = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  // Unified method to fetch reports based on selectedDate
  Future<void> _fetchReport() async {
    setState(() => isLoading = true);
    try {
      String month = selectedDate.month.toString();
      String year = selectedDate.year.toString();

      final reports = await ref
          .read(leaveRepositoryProvider)
          .getDayWiseLeaveReport(month, year);

      setState(() {
        dalilyReports = reports;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching report: $e")));
    }
  }

  // Opens Date Picker and refreshes data
  Future<void> _selectDate(BuildContext context) async {
    // This specifically opens a Month-only selection UI
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      // confirmWidget: const Text("Select", style: TextStyle(fontWeight: FontWeight.bold)),
      // cancelWidget: const Text("Cancel"),
    );

    if (picked != null &&
        (picked.month != selectedDate.month ||
            picked.year != selectedDate.year)) {
      setState(() {
        selectedDate = picked;
      });
      _fetchReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Report")),
      body: Column(
        children: [
          // Date Selector Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.edit_calendar, size: 18),
                  label: const Text("Change"),
                ),
              ],
            ),
          ),

          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LeaveReportChart(reports: dalilyReports),
            ),

            Expanded(
              child: dalilyReports.isEmpty
                  ? const Center(child: Text("No data found for this period."))
                  : ListView.builder(
                      itemCount: dalilyReports.length,
                      itemBuilder: (context, index) {
                        final report = dalilyReports[index];
                        return Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text("Date: ${report.sId}"),
                            subtitle: Text(
                              "${report.totalLeaves} people on leave",
                            ),
                            children:
                                report.breakdown
                                    ?.map(
                                      (b) => ListTile(
                                        leading: const Icon(Icons.person),
                                        title: Text(b.username ?? 'Unknown'),
                                        subtitle: Text(
                                          "${b.type}: ${b.reason}",
                                        ),
                                      ),
                                    )
                                    .toList() ??
                                [],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
