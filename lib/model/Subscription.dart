class SubscriptionPlan {
  bool? success;
  List<Data>? data;
  PurchaseSubacription? purchaseSubacription;

  SubscriptionPlan({this.success, this.data, this.purchaseSubacription});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    purchaseSubacription = json['purchase_subacription'] != null
        ? new PurchaseSubacription.fromJson(json['purchase_subacription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.purchaseSubacription != null) {
      data['purchase_subacription'] = this.purchaseSubacription!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? plan;
  int? totalAppointment;

  Data({this.id, this.name, this.plan, this.totalAppointment});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    plan = json['plan'];
    totalAppointment = json['total_appointment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['plan'] = this.plan;
    data['total_appointment'] = this.totalAppointment;
    return data;
  }
}

class PurchaseSubacription {
  int? id;
  int? doctorId;
  int? subscriptionId;
  int? duration;
  String? startDate;
  String? endDate;
  String? paymentType;
  int? amount;
  String? paymentToken;
  int? paymentStatus;
  int? status;
  String? createdAt;
  String? updatedAt;

  PurchaseSubacription(
      {this.id,
        this.doctorId,
        this.subscriptionId,
        this.duration,
        this.startDate,
        this.endDate,
        this.paymentType,
        this.amount,
        this.paymentToken,
        this.paymentStatus,
        this.status,
        this.createdAt,
        this.updatedAt});

  PurchaseSubacription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    subscriptionId = json['subscription_id'];
    duration = json['duration'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    paymentType = json['payment_type'];
    amount = json['amount'];
    paymentToken = json['payment_token'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['subscription_id'] = this.subscriptionId;
    data['duration'] = this.duration;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['payment_type'] = this.paymentType;
    data['amount'] = this.amount;
    data['payment_token'] = this.paymentToken;
    data['payment_status'] = this.paymentStatus;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
