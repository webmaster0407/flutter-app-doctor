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
import 'package:doctro/model/CancelAppointment.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:doctro/screens/SignIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctro/model/hospital.dart';

class CancelAppointmentScreen extends StatefulWidget {
  @override
  _CancelAppointmentScreen createState() => _CancelAppointmentScreen();
}

class _CancelAppointmentScreen extends State<CancelAppointmentScreen> {
  //Set Loader
  Future? cancelAppointment;

  //Set Height/Width Using MediaQuery
  late double width;
  late double height;

  //get preferences
  String? dname;

  String? dfullimage;

  String? phone;
  int? subscription;

  //Search view
  TextEditingController _search = TextEditingController();
  List<AppointmentCancel> _searchResult = [];
  List<AppointmentCancel> _userCancel = [];

  //get hospital data
  String? hospitalName, hospitalAddress;

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
      cancelAppointment = cancelappointment();
      doctorprofile();
      dname = SharedPreferenceHelper.getString(Preferences.name);
      dfullimage = SharedPreferenceHelper.getString(Preferences.image);
      phone = SharedPreferenceHelper.getString(Preferences.phone_no);
      subscription = SharedPreferenceHelper.getInt(Preferences.subscription_status);
    });
  }

  //Add Hosptal & CancelAppointment List Data
  List<Hospitalname> hospitalreq = [];
  List<AppointmentCancel> caneclappointmentreq = [];

  //Set Open Drawer
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        onRefresh: cancelappointment,
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
                                }else if (_drawerMenu[index] == getTranslated(context, drawer_callHistory).toString()) {
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
                                } else if (_drawer[index] == getTranslated(context, drawer_callHistory).toString()) {
                                  Navigator.popAndPushNamed(context, 'VideoCallHistory');
                                }else if (_drawer[index] == getTranslated(context, drawer_schedule_timing).toString()) {
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
                              title: Text(
                                _drawer[index],
                                style: TextStyle(color: hintColor),
                              ),
                            );
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
                          margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06, top: height * 0.01),
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
                                      hintText: getTranslated(context, search_cancel_appointment).toString(),
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
              future: cancelAppointment,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.02),
                              child: Text(
                                getTranslated(context, cancel_appointment_heading).toString(),
                                style: TextStyle(fontSize: width * 0.05, color: hintColor),
                              ),
                            ),
                            caneclappointmentreq.length == 0
                                ? Container(
                                    margin: EdgeInsets.only(top: height * 0.2),
                                    child: Container(
                                      child: Image.asset("assets/images/no-data.png"),
                                    ),
                                  )
                                : Container(
                                    color: divider,
                                    width: width * 1.0,
                                    margin: EdgeInsets.only(
                                      top: height * 0.02,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                                          child: Text(
                                            getTranslated(context, cancel_appointment_heading).toString(),
                                            style: TextStyle(fontSize: 16, color: hintColor),
                                          ),
                                        ),
                                        Text(
                                          getTranslated(context, cancel_appointment_length).toString() + " ${caneclappointmentreq.length} ",
                                          style: TextStyle(fontSize: 13, color: passwordVisibility),
                                        ),
                                      ],
                                    ),
                                  ),
                            _search.text.isNotEmpty
                                ? _searchResult.length > 0
                                    ? ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _searchResult.length,
                                        itemBuilder: (context, i) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: width * 0.06, right: width * 0.02),
                                                    child: Text(
                                                      _searchResult[i].time!,
                                                      style: TextStyle(fontSize: 16, color: passwordVisibility),
                                                    ),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                                                      height: 100,
                                                      width: width * 0.70,
                                                      child: Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                          ),
                                                          child: Column(children: <Widget>[
                                                            Container(
                                                              child: ListTile(
                                                                isThreeLine: true,
                                                                leading: SizedBox(
                                                                  height: 70,
                                                                  width: 60,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Container(
                                                                        decoration: new BoxDecoration(
                                                                            image: new DecorationImage(
                                                                                fit: BoxFit.fitHeight,
                                                                                image: NetworkImage(_searchResult[i].user!.fullImage!)))),
                                                                  ),
                                                                ),
                                                                title: Container(
                                                                  alignment: AlignmentDirectional.topStart,
                                                                  margin: EdgeInsets.only(
                                                                    top: height * 0.01,
                                                                  ),
                                                                  child: Text(
                                                                    _searchResult[i].patientName!,
                                                                    style: TextStyle(fontSize: 16.0),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                trailing: Container(
                                                                    child: Text(
                                                                  SharedPreferenceHelper.getString(Preferences.currency_symbol) +
                                                                      _searchResult[i].amount.toString(),
                                                                  style: TextStyle(fontSize: 16, color: hintColor),
                                                                )),
                                                                subtitle: Column(
                                                                  children: <Widget>[
                                                                    Container(
                                                                        alignment: AlignmentDirectional.topStart,
                                                                        child: Text(
                                                                          getTranslated(context, home_age_data).toString() +
                                                                              ":" +
                                                                              _searchResult[i].age.toString(),
                                                                          style: TextStyle(fontSize: 12, color: hintColor),
                                                                        )),
                                                                    Container(
                                                                      width: width * 0.6,
                                                                      alignment: AlignmentDirectional.topStart,
                                                                      child: Text(
                                                                        _searchResult[i].patientAddress!,
                                                                        style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 2,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ]))),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : Container(
                                        height: height / 1.5,
                                        child: Center(
                                            child: Container(
                                          margin: EdgeInsets.only(top: height * 0.02),
                                          child: Text(getTranslated(context, result_not_found).toString()),
                                        )))
                                : ListView.builder(
                                    itemCount: caneclappointmentreq.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    reverse: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: width * 0.06, right: width * 0.02),
                                                child: Text(
                                                  caneclappointmentreq[index].time!,
                                                  style: TextStyle(fontSize: 16, color: passwordVisibility),
                                                ),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                                                  height: 100,
                                                  width: width * 0.70,
                                                  child: Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15.0),
                                                      ),
                                                      child: Column(children: <Widget>[
                                                        Container(
                                                          child: ListTile(
                                                            isThreeLine: true,
                                                            leading: SizedBox(
                                                              height: 70,
                                                              width: 60,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: Container(
                                                                    decoration: new BoxDecoration(
                                                                        image: new DecorationImage(
                                                                            fit: BoxFit.fitHeight,
                                                                            image: NetworkImage(
                                                                                caneclappointmentreq[index].user!.fullImage!)))),
                                                              ),
                                                            ),
                                                            title: Container(
                                                              alignment: AlignmentDirectional.topStart,
                                                              margin: EdgeInsets.only(
                                                                top: height * 0.01,
                                                              ),
                                                              child: Text(caneclappointmentreq[index].patientName!,
                                                                  style: TextStyle(fontSize: 16.0),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1),
                                                            ),
                                                            trailing: Container(
                                                                child: Text(
                                                              SharedPreferenceHelper.getString(Preferences.currency_symbol) +
                                                                  caneclappointmentreq[index].amount.toString(),
                                                              style: TextStyle(fontSize: 16, color: hintColor),
                                                            )),
                                                            subtitle: Column(
                                                              children: <Widget>[
                                                                Container(
                                                                    alignment: AlignmentDirectional.topStart,
                                                                    child: Text(
                                                                      getTranslated(context, home_age_data).toString() +
                                                                          ":" +
                                                                          caneclappointmentreq[index].age.toString(),
                                                                      style: TextStyle(fontSize: 12, color: hintColor),
                                                                    )),
                                                                Container(
                                                                  width: width * 0.6,
                                                                  alignment: AlignmentDirectional.topStart,
                                                                  child: Text(
                                                                    caneclappointmentreq[index].patientAddress!,
                                                                    style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ]))),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }

  Future<void> logoutUser() async {
    SharedPreferenceHelper.clearPref();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SignIn()),
      ModalRoute.withName('SignIn'),
    );
  }

  Future<BaseModel<CancelAppointment>> cancelappointment() async {
    CancelAppointment response;
    try {
      caneclappointmentreq.clear();
      _userCancel.clear();
      response = await RestClient(RetroApi().dioData()).cancelappointmentrequest();
      setState(() {
        caneclappointmentreq.addAll(response.data!);
        _userCancel.addAll(response.data!);
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
    _userCancel.forEach((appointmentCancel) {
      if (appointmentCancel.patientName!.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(appointmentCancel);
      }
    });
    setState(() {});
  }
}
