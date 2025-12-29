class LeaveRequest {
  String? sId;
  UserId? userId;
  String? leaveType;
  DateTime? startDate;
  DateTime? endDate;
  String? reason;
  int? totalDays;
  String? status;
  String? requestedAt;
  int? iV;

  LeaveRequest({
    this.sId,
    this.userId,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.reason,
    this.totalDays,
    this.status,
    this.requestedAt,
    this.iV,
  });

  LeaveRequest.fromJson(Map<String, dynamic> json) {
    print('0======${json['userId']} === $json');
    sId = json['_id'];
    userId = json['userId'] != null
        ? UserId.fromJson(json['userId'])
        : UserId(sId: '', username: '');
    leaveType = json['leaveType'];
    startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : null;
    endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
    reason = json['reason'];
    totalDays = json['totalDays'];
    status = json['status'];
    requestedAt = json['requestedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['leaveType'] = this.leaveType;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['reason'] = this.reason;
    data['totalDays'] = this.totalDays;
    data['status'] = this.status;
    data['requestedAt'] = this.requestedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UserId {
  String? sId;
  String? username;

  UserId({this.sId, this.username});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    username = json['username'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    return data;
  }
}
