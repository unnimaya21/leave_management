import 'package:leave_management/domain/entities/leave_request_entity.dart';

class LeaveRequest extends LeaveRequestEntity {
  LeaveRequest({
    super.userId,
    super.id,
    required super.leaveType,
    required super.startDate,
    required super.endDate,
    required super.reason,
    required super.totalDays,
    required super.status,
    super.requestedAt,
    super.approvedAt,
    super.rejectedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (id != null) '_id': id,
      'leaveType': leaveType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      'totalDays': totalDays,
      'status': status,
      if (requestedAt != null) 'requestedAt': requestedAt!.toIso8601String(),
      if (approvedAt != null) 'approvedAt': approvedAt?.toIso8601String(),
      if (rejectedAt != null) 'rejectedAt': rejectedAt?.toIso8601String(),
    };
  }

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['_id'],
      userId: json['userId'],
      leaveType: json['leaveType'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      reason: json['reason'],
      totalDays: json['totalDays'] ?? 0,
      status: json['status'],
      requestedAt: DateTime.parse(json['requestedAt']),
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.parse(json['rejectedAt'])
          : null,
    );
  }
}
