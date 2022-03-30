// Class for api tags
class Apis {
  static const String baseUrl = 'Https://doctoraswan.com/api/';
                              //Please don't remove "/public/api/".

  static const String login = "doctor_login";
  static const String register = "doctor_register";
  static const String appointment = "doctor_appointment";
  static const String appointment_details = "appointment_details/{id}";
  static const String appointment_history = "appointment_history";
  static const String working_hours = "working_hours";
  static const String hospitals = "hospitals";
  static const String doctor_profile= "doctor_profile";
  static const String review = "doctor_review";
  static const String payment = "payment";
  static const String check_otp = "check_otp";
  static const String update_doctor = "update_doctor";
  static const String treatment = "treatment";
  static const String categories = "categories/{id}";
  static const String experties = "expertise/{id}";
  static const String subscription = "subscription";
  static const String add_perscription = "add_prescription";
  static const String setting  = "setting";
  static const String update_image = "doctor_update_image";
  static const String status_change = "status_change";
  static const String purchase_subscription = "purchase_subscrption";
  static const String cancel_appointment  = "cancel_appointment";
  static const String finance_detail = "finance_details";
  static const String update_time = "update_time";
  static const String change_password = "doctor_change_password";
  static const String forgot_password = "forgot_password";
  static const String notification ="notification";
  static const String all_medicines = "allMedicines";
  static const String resend_otp = "resendOtp/{id}";
  static const String videoCallAddHistory = "add_call_history";
  static const String videoCallShowHistory = "video_call_history";
}