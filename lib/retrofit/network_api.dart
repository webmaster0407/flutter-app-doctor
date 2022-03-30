import 'package:doctro/model/AllMedicines.dart';
import 'package:doctro/model/CancelAppointment.dart';
import 'package:doctro/model/ChangePassword.dart';
import 'package:doctro/model/DoctorStatusChange.dart';
import 'package:doctro/model/FinanceDetails.dart';
import 'package:doctro/model/ForgotPassword.dart';
import 'package:doctro/model/Notification.dart';
import 'package:doctro/model/ResentOtp.dart';
import 'package:doctro/model/UpdateTiming.dart';
import 'package:doctro/model/add_prescription.dart';
import 'package:doctro/model/appointmenthistory.dart';
import 'package:doctro/model/experties.dart';
import 'package:doctro/model/Treatment.dart';
import 'package:doctro/model/categories.dart';
import 'package:doctro/model/hospital.dart';
import 'package:doctro/model/login.dart';
import 'package:doctro/model/register.dart';
import 'package:doctro/model/appointment_details.dart';
import 'package:doctro/model/update_profileimage.dart';
import 'package:doctro/model/video_call_history_add_model.dart';
import 'package:doctro/model/video_call_history_show_model.dart';
import 'package:doctro/retrofit/apis.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:doctro/model/working_hours.dart';
import 'package:doctro/model/doctor_profile.dart';
import 'package:doctro/model/review.dart';
import 'package:doctro/model/payment.dart';
import 'package:doctro/model/otpverify.dart';
import 'package:doctro/model/today_appointment.dart';
import 'package:doctro/model/UpdateProfile.dart';
import 'package:doctro/model/settings.dart';
import 'package:doctro/model/purchaseSubscription.dart';
import 'package:doctro/model/Subscription.dart';

part 'network_api.g.dart';


@RestApi(baseUrl:Apis.baseUrl)


abstract class RestClient{
  factory RestClient(Dio dio,{String? baseUrl})=_RestClient;

  @POST(Apis.login)
  Future<Login> loginRequest(
      @Body() body);

  @POST(Apis.register)
  Future<Register> registerrequest(@Body() body);

  @GET(Apis.appointment)
  Future<TodaysAppointment> todayappointments();

  @GET(Apis.appointment_details)
  Future<Appointmentdetails> appointmentDetails(@Path() int? id);

  @GET(Apis.appointment_history)
  Future<AppointmentHistory> appointmentHistoryScreenRequest ();

  @GET(Apis.working_hours)
  Future<Workinghours> workinghours ();

  @GET(Apis.hospitals)
  Future<Hospitals> hospitalrequest ();

  @GET(Apis.doctor_profile)
  Future<Doctorprofile> doctorprofile ();

  @GET(Apis.review)
  Future<Review> reviewrequest();

  @GET(Apis.payment)
  Future<Payment> paymentrequest();

  @POST(Apis.check_otp)
  Future<Otpverify> otpverifyrequest(@Body() body);

  @POST(Apis.update_doctor)
  Future<UpdateProfile> updateprofile(@Body() body);

  @GET(Apis.treatment)
  Future<Treatment> treatmentrequest();

  @GET(Apis.categories)
  Future<Categories> categoryrequest(@Path() int? id);

  @GET(Apis.experties)
  Future<Experties> expertiserequest(@Path() int? id);

  @GET(Apis.subscription)
  Future<SubscriptionPlan> subscriptionrequest();

  @POST(Apis.add_perscription)
  Future<Addprescription> addprescripitonrequset(@Body() body);

  @GET(Apis.setting)
  Future<Setting> settingrequest();

  @POST(Apis.update_image)
  Future<Imageupload> uploadimage(@Body() body);

  @POST(Apis.purchase_subscription)
  Future<PurchaseSubscription> purchasesubscriptionrequest(@Body() body);

  @POST(Apis.status_change)
  Future<DoctorStatusChange> doctorstatuschangerequest(@Body() body);

  @GET(Apis.cancel_appointment)
  Future<CancelAppointment> cancelappointmentrequest();

  @GET(Apis.finance_detail)
  Future<FinanceDetails> purchasedetailsrequest();

  @POST(Apis.update_time)
  Future<UpdateTiming> updatetimingrequest (@Body() body);

  @POST(Apis.change_password)
  Future<ChangePasswordModel> changepasswordrequest (@Body() body);

  @POST(Apis.forgot_password)
  Future<ForgotPassword> forgotPasswordScreen (@Body() body);

  @GET(Apis.notification)
  Future<Notifications> notifications();

  @GET(Apis.all_medicines)
  Future<AllMedicines> allMedicines();

  @GET(Apis.resend_otp)
  Future<ResentOtp>  resentotprequest(@Path() int? id);

  @POST(Apis.videoCallAddHistory)
  Future<VideoCallHistoryAddModel> videoCallHistoryAddRequest(@Body() body);

  @GET(Apis.videoCallShowHistory)
  Future<VideoCallHistoryShowModel> videoCallHistoryShowRequest();
}