import 'package:leave_management/data/models/user_model.dart';

abstract class AuthRepository {
  // Future<List<User>> getPantry();
  Future<User> login(String email, String password);
  Future<User> signUp(User user);
  Future<bool> forgotPassword(String email);
  Future<bool> updateUser(User user);
}
