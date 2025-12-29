import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/data/models/leave_category_model.dart';
import 'package:leave_management/presentation/providers/leave_provider.dart';

class DashBoardGraphScreen extends ConsumerWidget {
  const DashBoardGraphScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetching the balance directly within the screen
    final balancesAsync = ref.watch(leaveBalancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Statistics"),
        actions: [
          // Refresh button to manually trigger a fetch
          IconButton(
            onPressed: () => ref.invalidate(leaveBalancesProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: balancesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (balances) {
          if (balances.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          // Aggregate totals for the Pie Chart
          int totalAvailable = balances.fold(
            0,
            (sum, item) => sum + item.available,
          );
          int totalUsed = balances.fold(0, (sum, item) => sum + item.used);
          int totalPending = balances.fold(
            0,
            (sum, item) => sum + item.pending,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Total Leave Distribution",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // --- Pie Chart ---
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _getSections(
                        totalAvailable,
                        totalUsed,
                        totalPending,
                      ),
                    ),
                  ),
                ),

                _buildLegend(),
                const SizedBox(height: 40),

                const Text(
                  "Comparison by Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // --- Bar Chart ---
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: _getBarGroups(balances),
                      titlesData: _getTitlesData(balances),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Chart Helper Methods ---

  List<PieChartSectionData> _getSections(int available, int used, int pending) {
    return [
      PieChartSectionData(
        value: available.toDouble(),
        color: Colors.green,
        title: 'Avail',
        radius: 50,
        showTitle: false,
      ),
      PieChartSectionData(
        value: used.toDouble(),
        color: Colors.redAccent,
        title: 'Used',
        radius: 55,
        showTitle: false,
      ),
      PieChartSectionData(
        value: pending.toDouble(),
        color: Colors.orange,
        title: 'Pend',
        radius: 50,
        showTitle: false,
      ),
    ];
  }

  List<BarChartGroupData> _getBarGroups(List<LeaveCategory> balances) {
    return balances.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.total.toDouble(),
            color: Colors.grey[300],
            width: 12,
          ),
          BarChartRodData(
            toY: (entry.value.used + entry.value.pending).toDouble(),
            color: _getCategoryColor(entry.value.name),
            width: 12,
          ),
        ],
      );
    }).toList();
  }

  FlTitlesData _getTitlesData(List<LeaveCategory> balances) {
    return FlTitlesData(
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index < 0 || index >= balances.length) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                balances[index].name.substring(0, 3).toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Wrap(
        spacing: 20,
        children: [
          _legendItem("Available", Colors.green),
          _legendItem("Used", Colors.redAccent),
          _legendItem("Pending", Colors.orange),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
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
