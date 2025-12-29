import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management/data/models/leave_category_model.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
import 'package:leave_management/data/repositories/leave_repository_impl.dart';
import 'package:leave_management/di/di.dart';
import 'package:leave_management/domain/repositories/leave_repository.dart';

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  final dio = ref.watch(dioProvider); // Get Dio instance from dioProvider
  return LeaveRepositoryImpl(dio);
});

final newLeaverequestProvider =
    FutureProvider.family<LeaveRequest, LeaveRequest>((
      ref,
      leaveRequest,
    ) async {
      print("Inside newLeaverequestProvider with LeaveRequest: $leaveRequest");
      final leaveRepository = ref.watch(leaveRepositoryProvider);
      return leaveRepository.newLeaveRequest(leaveRequest);
    });
final getLeaveRequestsProvider = FutureProvider<List<LeaveRequest>>((
  ref,
) async {
  final leaveRepository = ref.watch(leaveRepositoryProvider);
  return leaveRepository.getLeaveRequests();
});

final withdrawLeaveRequestProvider = FutureProvider.family<bool, String>((
  ref,
  requestId,
) async {
  final leaveRepository = ref.watch(leaveRepositoryProvider);
  return await leaveRepository.withdrawLeaveRequest(requestId);
});
final leaveBalancesProvider = FutureProvider<List<LeaveCategory>>((ref) async {
  final repository = ref.watch(leaveRepositoryProvider);
  return repository.getLeaveBalances();
});
