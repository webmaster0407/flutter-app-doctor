import 'package:doctro/model/ResentOtp.dart';
import 'package:doctro/model/otpverify.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final OtpData? data;
  PhoneVerificationScreen({this.data});

  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {

//Set Height/Width Using MediaQuery
  late double width;
  late double height;

  int? id = 0;

  //Set TextInputController In OTP
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: deepPurple),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void initState() {
    id = widget.data!.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width * 0.05, height * 0.05),
        child: SafeArea(
          child: Container(
              alignment: AlignmentDirectional.topStart,
              margin: EdgeInsets.only(
                  top: height * 0.025, left: width * 0.05),
              child: GestureDetector(
                child: Icon(Icons.arrow_back_ios),
                onTap: () {
                  Navigator.pushNamed(context, 'SignIn');
                },
              )),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.1,
                  left: width * 0.073,
                  right: width * 0.073),
              child: Text(
                getTranslated(context, phone_verification_title).toString(),
                style: TextStyle(
                    fontSize: width * 0.09,
                    fontWeight: FontWeight.bold,
                    color: hintColor),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.040),
              child: Text(
                getTranslated(context, phone_enter_your_otp_code).toString(),
                style: TextStyle(
                    fontSize: width * 0.040, color: hintColor),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: width * 0.063,
                  right: width * 0.063,
                  top: height * 0.052),
              child: PinPut(
              fieldsCount: 4,
              autofocus: true,
              textStyle: TextStyle(
                  fontSize: width * 0.04, color: colorWhite),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                color: loginButton,
                border: Border.all(
                  color: tealAccent.withOpacity(.2),
                ),
              ),
              selectedFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(20.0),
                color: divider,
                border: Border.all(
                  color: tealAccent.withOpacity(.2),
                ),
              ),
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                color: divider,
                border: Border.all(
                  color: tealAccent.withOpacity(.2),
                ),
              ),
            ),
            ),

            Container(
              margin: EdgeInsets.only(left:width*0.2,right:width*0.2,top: height*0.040),
              child: Column(
                children: [
                  Text(
                    getTranslated(context, phone_otp_not_received).toString(),
                    style: TextStyle(fontSize:width*0.04,color: hintColor),
                  ),
                  Container(
                    margin:
                    EdgeInsets.symmetric( vertical: width * 0.02),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            resentotpverify();
                          },
                          child: Text(
                            getTranslated(context, phone_resend_new_code ).toString(),
                            style: TextStyle(
                                color:loginButton,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height*0.02),
                    child: ElevatedButton(
                        child: Text(
                          getTranslated(context, phone_verify_otp).toString(),
                          style: TextStyle(
                              fontSize: width * 0.04,
                              height: height * 0.0018),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                            otpverify();
                        }
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<BaseModel<Otpverify>> otpverify() async {
    Map<String, dynamic> body = {
      "user_id": id,
      "otp": _pinPutController.text,
    };
    Otpverify response;
    try {
      response = await RestClient(RetroApi().dioData()).otpverifyrequest(body);
      if(response.success==true){
        Navigator.pushReplacementNamed(context, "SignIn");
        Fluttertoast.showToast(
          msg: response.msg!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      else {
        Fluttertoast.showToast(
          msg: response.msg!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<ResentOtp>> resentotpverify() async {

    ResentOtp response;
    try {
      response = await RestClient(RetroApi().dioData()).resentotprequest(id);

        Navigator.pushNamed(context, 'SignIn');
        Fluttertoast.showToast(
          msg: response.msg!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
