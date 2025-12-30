class UserEntity {
  String id;
  String username;
  String email;
  String password;
  String department;
  String designation;
  String joinedDate;
  String? role;
  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.department,
    required this.designation,
    required this.joinedDate,
    this.role,
  });
}
