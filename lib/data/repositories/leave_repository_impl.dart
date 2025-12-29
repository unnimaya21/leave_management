import 'package:dio/dio.dart';
import 'package:leave_management/core/services/error_service.dart';
import 'package:leave_management/data/models/leave_category_model.dart';
import 'package:leave_management/data/models/leave_request_model.dart';
import 'package:leave_management/domain/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final Dio _dio;
  LeaveRepositoryImpl(this._dio);
  @override
  Future<LeaveRequest> newLeaveRequest(LeaveRequest leaveRequest) async {
    try {
      final response = await _dio.post(
        '/leaves/newLeaveRequest',
        data: leaveRequest.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeaveRequest.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to create leave request: ${response.statusMessage}',
        );
      }
    } on DioException catch (error) {
      String message = "Something went wrong!";

      message = error.response?.data['message'] ?? error.message ?? message;
      ErrorService.showError(message);
      throw Exception('Failed to create leave request: $message');
    } catch (e) {
      throw Exception('Failed to create leave request: $e');
    }
  }

  @override
  Future<List<LeaveRequest>> getLeaveRequests() async {
    try {
      final response = await _dio.get('/leaves');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List<dynamic>) {
          final List<dynamic> leaveRequestsJson = data['data'];
          return leaveRequestsJson
              .map((json) => LeaveRequest.fromJson(json))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
          'Failed to fetch leave requests: ${response.statusMessage}',
        );
      }
    } on DioException catch (error) {
      String message = "Something went wrong!";

      message = error.response?.data['message'] ?? error.message ?? message;
      ErrorService.showError(message);
      throw Exception('Failed to fetch leave requests: $message');
    } catch (e) {
      throw Exception('Failed to fetch leave requests: $e');
    }
  }

  @override
  Future<bool> withdrawLeaveRequest(String requestId) {
    try {
      return _dio.patch('/leaves/withdraw/$requestId').then((response) {
        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception(
            'Failed to withdraw leave request: ${response.statusMessage}',
          );
        }
      });
    } on DioException catch (error) {
      String message = "Something went wrong!";

      message = error.response?.data['message'] ?? error.message ?? message;
      ErrorService.showError(message);
      throw Exception('Failed to withdraw leave request: $message');
    } catch (e) {
      throw Exception('Failed to withdraw leave request: $e');
    }
  }

  @override
  Future<List<LeaveCategory>> getLeaveBalances() async {
    try {
      final response = await _dio.get('/leaves/leave-balance');
      if (response.statusCode == 200) {
        final data =
            response.data['data']; // This is the object containing 'categories'

        if (data != null && data['categories'] is Map<String, dynamic>) {
          final Map<String, dynamic> categoriesMap = data['categories'];

          // Transform the Map keys/values into a List of LeaveCategory
          return categoriesMap.entries.map((entry) {
            return LeaveCategory.fromJson(entry.key, entry.value);
          }).toList();
        } else {
          throw Exception('Categories not found in response');
        }
      } else {
        throw Exception('Failed to fetch leave balances');
      }
    } on DioException catch (error) {
      String message =
          error.response?.data['message'] ?? error.message ?? "Error";
      ErrorService.showError(message);
      throw Exception(message);
    }
  }
}
