class TodaysAppointment {
  bool? success;
  List<Datas>? data;
  String? msg;

  TodaysAppointment({this.success, this.data, this.msg});

  TodaysAppointment.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Datas.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Datas {
  int? id;
  String? time;
  String? date;
  int? age;
  String? patientName;
  int? amount;
  String? patientAddress;
  int? userId;
  User? user;

  Datas(
      {this.id,
        this.time,
        this.date,
        this.age,
        this.patientName,
        this.amount,
        this.patientAddress,
        this.userId,
        this.user});

  Datas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    date = json['date'];
    age = json['age'];
    patientName = json['patient_name'];
    amount = json['amount'];
    patientAddress = json['patient_address'];
    userId = json['user_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['date'] = this.date;
    data['age'] = this.age;
    data['patient_name'] = this.patientName;
    data['amount'] = this.amount;
    data['patient_address'] = this.patientAddress;
    data['user_id'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? image;
  String? fullImage;

  User({this.id, this.image, this.fullImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    fullImage = json['fullImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['fullImage'] = this.fullImage;
    return data;
  }
}
