class Changestatus {
  bool? success;
  String? msg;

  Changestatus({this.success, this.msg});

  Changestatus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    return data;
  }
}
