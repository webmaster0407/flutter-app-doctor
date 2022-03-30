class Addprescription {
  bool? success;
  String? msg;

  Addprescription({this.success, this.msg});

  Addprescription.fromJson(Map<String, dynamic> json) {
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
