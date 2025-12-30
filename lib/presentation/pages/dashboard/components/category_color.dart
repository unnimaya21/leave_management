import 'package:flutter/material.dart';

Color getCategoryColor(String name) {
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
