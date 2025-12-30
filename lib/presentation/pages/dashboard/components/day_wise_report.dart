import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:leave_management/data/models/leave_report_model.dart';

class LeaveReportChart extends StatelessWidget {
  final List<DailyLeaveReport> reports;

  const LeaveReportChart({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              // maxY: _calculateMaxY(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final report = reports[groupIndex];
                    return BarTooltipItem(
                      '${report.sId}\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '${report.totalLeaves} Leaves',
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= reports.length)
                        return const SizedBox();
                      // Show only day number to save space: "2025-12-30" -> "30"
                      String day = reports[index].sId?.split('-').first ?? '';
                      return Text(day, style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: reports.asMap().entries.map((entry) {
                int index = entry.key;
                var data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: data.totalLeaves?.toDouble() ?? 0,
                      color: _getBarColor(data.totalLeaves ?? 0),
                      width: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // double _calculateMaxY() {
  //   if (reports.isEmpty) return 5;
  //   double max = reports
  //       .map((e) => e!.totalLeaves ?? 0)
  //       .reduce((a, b) => a > b ? a : b)
  //       .toDouble();
  //   return max + 2; // Add padding to top
  // }

  Color _getBarColor(int count) {
    if (count >= 5) return Colors.redAccent;
    if (count >= 3) return Colors.orangeAccent;
    return Colors.blueAccent;
  }
}
