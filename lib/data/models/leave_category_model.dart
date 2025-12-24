class LeaveCategory {
  final String name;
  final int total;
  final int used;
  final int pending;
  final int available;

  LeaveCategory({
    required this.name,
    required this.total,
    required this.used,
    required this.pending,
    required this.available,
  });

  factory LeaveCategory.fromJson(String name, Map<String, dynamic> json) {
    return LeaveCategory(
      name: name,
      total: json['total'],
      used: json['used'],
      pending: json['pending'],
      available: json['available'],
    );
  }
}
