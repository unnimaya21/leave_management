import 'package:flutter/material.dart';

Widget buildStatusChip(String status) {
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
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
    ),
  );
}
