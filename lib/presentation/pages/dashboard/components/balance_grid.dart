import 'package:flutter/material.dart';
import 'package:leave_management/data/models/leave_category_model.dart';
import 'package:leave_management/presentation/pages/dashboard/components/category_color.dart';
import 'package:leave_management/presentation/pages/dashboard/components/stat_card.dart';

Widget buildBalancesGrid(List<LeaveCategory> balances) {
  int totalUsed = balances.fold(0, (sum, b) => sum + b.used);
  int totalLeaves = balances.fold(0, (sum, b) => sum + b.total);
  int totalPending = balances.fold(0, (sum, b) => sum + b.pending);
  return GridView.builder(
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
        return buildStatCard(
          "Total Used",
          '${totalUsed + totalPending}/$totalLeaves',
          Colors.redAccent, // Distinct color for the total
        );
      }
      final balance = balances[index];
      return buildStatCard(
        '${balance.name[0].toUpperCase()}${balance.name.substring(1)} Leave', // Capitalize
        '${balance.used + balance.pending}/${balance.total.toString()}',
        getCategoryColor(balance.name),
      );
    },
  );
}
