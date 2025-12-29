import 'package:equatable/equatable.dart';

class LeaveRequestEntity extends Equatable {
  final String? id;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final int? totalDays;
  final String leaveType;
  final String? userId;
  final String status;
  final DateTime? requestedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final UserID? userID;

  LeaveRequestEntity({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.totalDays,
    required this.leaveType,
    this.userId,
    required this.status,
    this.requestedAt,
    this.approvedAt,
    this.rejectedAt,
    this.userID,
  });
  @override
  List<Object?> get props => [
    id,
    startDate,
    endDate,
    reason,
    totalDays,
    leaveType,
    userId,
    status,
    requestedAt,
    approvedAt,
    rejectedAt,
    userID,
  ];
}

// User model for nested userID
class UserID {
  final String username;
  final String id;

  UserID({required this.username, required this.id});

  factory UserID.fromJson(Map<String, dynamic> json) {
    return UserID(username: json['username'], id: json['_id']);
  }
}
