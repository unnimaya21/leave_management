class DailyLeaveReport {
  String? sId;
  int? totalLeaves;
  List<Breakdown>? breakdown;

  DailyLeaveReport({this.sId, this.totalLeaves, this.breakdown});

  DailyLeaveReport.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    totalLeaves = json['totalLeaves'];
    if (json['breakdown'] != null) {
      breakdown = <Breakdown>[];
      json['breakdown'].forEach((v) {
        breakdown!.add(new Breakdown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['totalLeaves'] = this.totalLeaves;
    if (this.breakdown != null) {
      data['breakdown'] = this.breakdown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Breakdown {
  String? type;
  String? username;
  String? reason;

  Breakdown({this.type, this.username, this.reason});

  Breakdown.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    username = json['username'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['username'] = this.username;
    data['reason'] = this.reason;
    return data;
  }
}
