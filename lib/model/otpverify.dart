class Otpverify {
  bool? success;
  OtpData? data;
  String? msg;

  Otpverify({this.success, this.data, this.msg});

  Otpverify.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new OtpData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class OtpData {
  int? id;
  String? name;
  String? email;
  Null emailVerifiedAt;
  String? phone;
  String? phoneCode;
  int? verify;
  int? otp;
  Null dob;
  Null gender;
  Null image;
  int? status;
  Null doctorId;
  Null deviceToken;
  String? createdAt;
  String? updatedAt;
  String? token;
  String? fullImage;

  OtpData(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.phone,
        this.phoneCode,
        this.verify,
        this.otp,
        this.dob,
        this.gender,
        this.image,
        this.status,
        this.doctorId,
        this.deviceToken,
        this.createdAt,
        this.updatedAt,
        this.token,
        this.fullImage});

  OtpData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    phoneCode = json['phone_code'];
    verify = json['verify'];
    otp = json['otp'];
    dob = json['dob'];
    gender = json['gender'];
    image = json['image'];
    status = json['status'];
    doctorId = json['doctor_id'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    token = json['token'];
    fullImage = json['fullImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    data['phone_code'] = this.phoneCode;
    data['verify'] = this.verify;
    data['otp'] = this.otp;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['status'] = this.status;
    data['doctor_id'] = this.doctorId;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['token'] = this.token;
    data['fullImage'] = this.fullImage;
    return data;
  }
}
