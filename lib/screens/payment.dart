import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/model/doctor_profile.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/constant/commn_function.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:doctro/screens/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doctro/model/payment.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreen createState() => _PaymentScreen();
}

class _PaymentScreen extends State<PaymentScreen> {
  //Set Height/Width Using MediaQuery
  late double width;
  late double height;

  //Set DrawerOpen
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Set Loader
  Future? payments;

  //Set Total Value
  static int sum = 0;

  //get shared preferences
  String? dname;
  String? dfullimage;
  String? phone;
  int? subscription;

  //get hospital data
  String? hospitalName, hospitalAddress;

  //Search view
  TextEditingController _search = TextEditingController();
  List<Payments> _searchResult = [];
  List<Payments> _userPayment = [];

  List<String> _drawer = [];
  List<String> _drawerMenu = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Set Drawer Menu Item List
    _drawer = [
      getTranslated(context, drawer_home).toString(),
      getTranslated(context, drawer_payments).toString(),
      getTranslated(context, drawer_canceled_appointment).toString(),
      getTranslated(context, drawer_appointments).toString(),
      getTranslated(context, drawer_review).toString(),
      getTranslated(context, drawer_notification).toString(),
      getTranslated(context, drawer_callHistory).toString(),
      getTranslated(context, drawer_schedule_timing).toString(),
      getTranslated(context, drawer_subscription_history).toString(),
      getTranslated(context, drawer_change_password).toString(),
      getTranslated(context, drawer_change_language).toString(),
      getTranslated(context, drawer_logout).toString(),
    ];

    _drawerMenu = [
      getTranslated(context, drawer_home).toString(),
      getTranslated(context, drawer_payments).toString(),
      getTranslated(context, drawer_canceled_appointment).toString(),
      getTranslated(context, drawer_appointments).toString(),
      getTranslated(context, drawer_review).toString(),
      getTranslated(context, drawer_notification).toString(),
      getTranslated(context, drawer_callHistory).toString(),
      getTranslated(context, drawer_schedule_timing).toString(),
      getTranslated(context, drawer_change_password).toString(),
      getTranslated(context, drawer_change_language).toString(),
      getTranslated(context, drawer_logout).toString(),
    ];
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      doctorprofile();
      payments = paymentsfunction();
      dname = SharedPreferenceHelper.getString(Preferences.name);
      dfullimage = SharedPreferenceHelper.getString(Preferences.image);
      phone = SharedPreferenceHelper.getString(Preferences.phone_no);
      subscription = SharedPreferenceHelper.getInt(Preferences.subscription_status);
    });
  }

  //Set Visible Or Not length (Minimum 5)
  bool _patmentreq = false;

  //Add Payment List Data
  List<Payments> paymentsreq = [];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamedAndRemoveUntil(context, 'loginhome', (route) => false);
        return Future<bool>.value(false);
      },
      child: RefreshIndicator(
        onRefresh: paymentsfunction,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: DrawerHeader(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: new BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            new BoxShadow(
                              color: imageBorder,
                              blurRadius: 1.0,
                            ),
                          ]),
                          child: CachedNetworkImage(
                            alignment: Alignment.center,
                            imageUrl: '$dfullimage',
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 50,
                              backgroundColor: colorWhite,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.asset("assets/images/no_image.jpg"),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              width: width * 0.35,
                              child: Text(
                                '$dname',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 18, color: hintColor),
                              ),
                            ),
                            Text(
                              "$phone",
                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, "profile");
                          },
                          child: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            height: height * 0.025,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 11,
                  child: subscription == -1
                      ? ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: false,
                          scrollDirection: Axis.vertical,
                          itemCount: _drawerMenu.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                if (_drawerMenu[index] == getTranslated(context, drawer_home).toString()) {
                                  Navigator.popAndPushNamed(context, "loginhome");
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_payments).toString()) {
                                  Navigator.popAndPushNamed(context, 'payment');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_canceled_appointment).toString()) {
                                  Navigator.popAndPushNamed(context, 'cancelappoitment');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_appointments).toString()) {
                                  Navigator.popAndPushNamed(context, 'AppointmentHistoryScreen');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_review).toString()) {
                                  Navigator.popAndPushNamed(context, 'rateandreview');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_notification).toString()) {
                                  Navigator.popAndPushNamed(context, 'notifications');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_callHistory).toString()) {
                                  Navigator.popAndPushNamed(context, 'VideoCallHistory');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_schedule_timing).toString()) {
                                  Navigator.popAndPushNamed(context, 'Schedule Timings');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_change_password).toString()) {
                                  Navigator.popAndPushNamed(context, 'Change Password');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_change_language).toString()) {
                                  Navigator.popAndPushNamed(context, 'Change Language');
                                } else if (_drawerMenu[index] == getTranslated(context, drawer_logout).toString()) {
                                  showAlertDialog(context);
                                }
                              },
                              title: Text(
                                _drawerMenu[index],
                                style: TextStyle(color: hintColor),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: false,
                          scrollDirection: Axis.vertical,
                          itemCount: _drawer.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return ListTile(
                                onTap: () {
                                  if (_drawer[index] == getTranslated(context, drawer_home).toString()) {
                                    Navigator.popAndPushNamed(context, "loginhome");
                                  } else if (_drawer[index] == getTranslated(context, drawer_payments).toString()) {
                                    Navigator.popAndPushNamed(context, 'payment');
                                  } else if (_drawer[index] == getTranslated(context, drawer_canceled_appointment).toString()) {
                                    Navigator.popAndPushNamed(context, 'cancelappoitment');
                                  } else if (_drawer[index] == getTranslated(context, drawer_appointments).toString()) {
                                    Navigator.popAndPushNamed(context, 'AppointmentHistoryScreen');
                                  } else if (_drawer[index] == getTranslated(context, drawer_review).toString()) {
                                    Navigator.popAndPushNamed(context, 'rateandreview');
                                  } else if (_drawer[index] == getTranslated(context, drawer_notification).toString()) {
                                    Navigator.popAndPushNamed(context, 'notifications');
                                  }else if (_drawer[index] == getTranslated(context, drawer_callHistory).toString()) {
                                    Navigator.popAndPushNamed(context, 'VideoCallHistory');
                                  }  else if (_drawer[index] == getTranslated(context, drawer_schedule_timing).toString()) {
                                    Navigator.popAndPushNamed(context, 'Schedule Timings');
                                  } else if (_drawer[index] == getTranslated(context, drawer_subscription_history).toString()) {
                                    Navigator.popAndPushNamed(context, 'Subscription History');
                                  } else if (_drawer[index] == getTranslated(context, drawer_change_password).toString()) {
                                    Navigator.popAndPushNamed(context, 'Change Password');
                                  } else if (_drawer[index] == getTranslated(context, drawer_change_language).toString()) {
                                    Navigator.popAndPushNamed(context, 'Change Language');
                                  } else if (_drawer[index] == getTranslated(context, drawer_logout).toString()) {
                                    showAlertDialog(context);
                                  }
                                },
                                title: Text(_drawer[index], style: TextStyle(color: hintColor)));
                          },
                        ),
                ),
              ],
            ),
          ),
          appBar: PreferredSize(
              preferredSize: Size(20, 160),
              child: SafeArea(
                  top: true,
                  child: Column(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: width * 0.06, right: width * 0.04, top: height * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/location.svg',
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: hospitalName == null ? Container() : Text('$hospitalName'),
                                  ),
                                  hospitalAddress == null
                                      ? Container()
                                      : Container(
                                          width: width * 0.6,
                                          child: Text(
                                            "$hospitalAddress",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: width * 0.030, color: hintColor),
                                          ),
                                        ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(),
                                child: IconButton(
                                  onPressed: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                  icon: SvgPicture.asset(
                                    "assets/icons/dmenubar.svg",
                                    height: 16.0,
                                    // width: 15.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.01),
                      padding: EdgeInsets.all(10),
                      child: Card(
                        color: colorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                            alignment: AlignmentDirectional.center,
                            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: height * 0.06,
                                  width: width * 0.7,
                                  child: TextField(
                                    controller: _search,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: getTranslated(context, payment_search).toString(),
                                      hintStyle: TextStyle(
                                        fontSize: width * 0.045,
                                        color: hintColor.withOpacity(0.3),
                                      ),
                                    ),
                                    onChanged: onSearchTextChanged,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/icons/dsearch.svg',
                                    height: 20,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ]))),
          body: FutureBuilder(
              future: payments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06, top: height * 0.02),
                            child: Text(
                              getTranslated(context, payment_title).toString(),
                              style: TextStyle(fontSize: width * 0.05, color: hintColor),
                            ),
                          ),
                          paymentsreq.length == 0
                              ? Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: height * 0.2),
                                    child: Container(
                                      child: Image.asset("assets/images/no-data.png"),
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06, top: height * 0.020),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getTranslated(context, payment_patient_list).toString(),
                                        style: TextStyle(fontSize: width * 0.05, color: hintColor),
                                      ),
                                      Text(
                                        getTranslated(context, payment_total).toString() + " ${paymentsreq.length}",
                                        style: TextStyle(fontSize: width * 0.030, color: passwordVisibility),
                                      ),
                                    ],
                                  ),
                                ),
                          _search.text.isNotEmpty
                              ? _searchResult.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _searchResult.length,
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: width * 0.06, top: height * 0.04, right: width * 0.06),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    _searchResult[i].user!.name!,
                                                    style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                  ),
                                                  Text(
                                                    SharedPreferenceHelper.getString(Preferences.currency_symbol) +
                                                        _searchResult[i].amount.toString(),
                                                    style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06, top: height * 0.02),
                                              child: Divider(
                                                height: height * 0.005,
                                                thickness: width * 0.005,
                                                color: divider,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Container(
                                      margin: EdgeInsets.only(top: height * 0.02),
                                      child: Text(
                                        getTranslated(context, result_not_found).toString(),
                                      ),
                                    ))
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: _patmentreq == false && paymentsreq.length > 5 ? 5 : paymentsreq.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: width * 0.06, top: height * 0.04, right: width * 0.06),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                paymentsreq[index].user!.name!,
                                                style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              ),
                                              Text(
                                                SharedPreferenceHelper.getString(Preferences.currency_symbol) +
                                                    paymentsreq[index].amount.toString(),
                                                style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06, top: height * 0.02),
                                          child: Divider(
                                            height: height * 0.005,
                                            thickness: width * 0.005,
                                            color: divider,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                          paymentsreq.length < 5
                              ? Container()
                              : Visibility(
                                  visible: _patmentreq == true ? false : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _patmentreq = true;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: height * 0.02),
                                      alignment: AlignmentDirectional.centerStart,
                                      height: height * 0.07,
                                      width: width * 0.88,
                                      color: divider,
                                      child: Container(
                                        margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              getTranslated(context, view_all_payment).toString(),
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: hintColor),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(right: width * 0.4),
                                              child: SvgPicture.asset(
                                                'assets/icons/longarrow.svg',
                                                height: height * 0.012,
                                              ),
                                            ),
                                            Text(
                                              "${paymentsreq.length}",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: hintColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          paymentsreq.length == 0
                              ? Container()
                              : Container(
                                  height: height * 0.07,
                                  width: width * 1.0,
                                  margin: EdgeInsets.only(top: height * 0.04),
                                  color: loginButton,
                                  child: Container(
                                    margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated(context, payment_rs_total).toString(),
                                          style: TextStyle(fontSize: 16, color: colorWhite),
                                        ),
                                        Text(
                                          SharedPreferenceHelper.getString(Preferences.currency_symbol) + "$sum",
                                          style: TextStyle(fontSize: 16, color: colorWhite),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }

  Future<void> logoutUser() async {
    SharedPreferenceHelper.clearPref();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => SignIn()), ModalRoute.withName('SignIn'));
  }

  Future<BaseModel<Payment>> paymentsfunction() async {
    Payment response;
    try {
      paymentsreq.clear();
      _userPayment.clear();
      response = await RestClient(RetroApi().dioData()).paymentrequest();
      setState(() {
        paymentsreq.addAll(response.paymentdata!);
        _userPayment.addAll(response.paymentdata!);

        sum = 0;
        for (int i = 0; i < paymentsreq.length; i++) {
          sum += paymentsreq[i].amount!;
        }
        setState(() {});
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Payment>> allMedicinesreq() async {
    Payment response;
    try {
      paymentsreq.clear();
      _userPayment.clear();
      response = await RestClient(RetroApi().dioData()).paymentrequest();
      setState(() {
        paymentsreq.addAll(response.paymentdata!);
        _userPayment.addAll(response.paymentdata!);

        sum = 0;
        for (int i = 0; i < paymentsreq.length; i++) {
          sum += paymentsreq[i].amount!;
        }
        setState(() {});
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Doctorprofile>> doctorprofile() async {
    Doctorprofile response;
    try {
      response = await RestClient(RetroApi().dioData()).doctorprofile();
      setState(() {
        hospitalName = response.data!.hospital!.name;
        hospitalAddress = response.data!.hospital!.address;
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cancel = TextButton(
      child: Text(
        getTranslated(context, cancel_button).toString(),
        style: TextStyle(color: hintColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text(
        getTranslated(context, logout_button).toString(),
        style: TextStyle(color: hintColor),
      ),
      onPressed: () {
        CommonFunction.checkNetwork().then((value) {
          if (value == true) {
            logoutUser();
          }
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(getTranslated(context, are_you_sure_logout).toString()),
      actions: [cancel, okButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userPayment.forEach((payment) {
      if (payment.user!.name!.toLowerCase().contains(text.toLowerCase())) _searchResult.add(payment);
    });
    setState(() {});
  }
}
