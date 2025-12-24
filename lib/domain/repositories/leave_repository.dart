import 'package:leave_management/data/models/leave_category_model.dart';
import 'package:leave_management/data/models/leave_request_model.dart';

abstract class LeaveRepository {
  Future<LeaveRequest> newLeaveRequest(LeaveRequest leaveRequest);
  Future<List<LeaveRequest>> getLeaveRequests();
  Future<bool> withdrawLeaveRequest(String requestId);
  Future<List<LeaveCategory>> getLeaveBalances();
}
