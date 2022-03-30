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
import 'package:doctro/model/today_appointment.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:doctro/screens/PhoneScreen.dart';
import 'package:doctro/screens/SignIn.dart';
import 'package:doctro/screens/SubScription.dart';
import 'package:doctro/screens/patient_information.dart';
import 'package:doctro/screens/video_Call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

class LoginHome extends StatefulWidget {
  @override
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  //Set Loader
  Future? todayappointments;

  late RtcEngine _engine;

  //Set Open Drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Set Preferences Data
  String? dname;
  String? dfullimage;
  int? isfilled;
  int? subscription;
  String? phone;

  //Search Data
  TextEditingController _search = TextEditingController();
  List<Datas> _searchResult = [];
  List<Datas> _todayUserAppointment = [];

  //getHospital Data
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
      getOneSingleToken();

      todayappointments = todayappointmentsFunction();
      doctorprofile();
      dname = SharedPreferenceHelper.getString(Preferences.name);
      dfullimage = SharedPreferenceHelper.getString(Preferences.image);
      isfilled = SharedPreferenceHelper.getInt(Preferences.is_filled);
      subscription = SharedPreferenceHelper.getInt(Preferences.subscription_status);
      phone = SharedPreferenceHelper.getString(Preferences.phone_no);
    });
  }

  //Set Double Tap to exit value
  DateTime? currentBackPressTime;

  //Set Double Tap exit
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(gravity: ToastGravity.BOTTOM, msg: getTranslated(context, tap_again_to_exit_app).toString());
      return Future.value(false);
    }
    return Future.value(true);
  }

  //Add List Data
  List<Datas> todayappointmentsreq = [];

  //Set MediaQuery Size
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Container(
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
                                } else if (_drawer[index] == getTranslated(context, drawer_callHistory).toString()) {
                                  Navigator.popAndPushNamed(context, 'VideoCallHistory');
                                } else if (_drawer[index] == getTranslated(context, drawer_schedule_timing).toString()) {
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
                          height: height * 0.06,
                          alignment: AlignmentDirectional.center,
                          margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: height * 0.07,
                                width: width * 0.6,
                                child: TextField(
                                  controller: _search,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: getTranslated(context, home_search_hint).toString(),
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
        body: RefreshIndicator(
          onRefresh: todayappointmentsFunction,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
                future: todayappointments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      child: subscription == 0
                          ? dialog()
                          : Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isfilled == 0
                                      ? GestureDetector(
                                          onTap: () => Navigator.pushNamed(context, "profile"),
                                          child: Container(
                                            width: width * 1.0,
                                            color: tabBar.withOpacity(0.8),
                                            margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06, bottom: height * 0.02),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        left: width * 0.02,
                                                      ),
                                                      child: Icon(
                                                        Icons.warning,
                                                        size: 28,
                                                        color: purple,
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width * 0.02),
                                                        child: Text(getTranslated(context, home_please_update_profile).toString(),
                                                            style: TextStyle(fontSize: 16, color: purple))),
                                                    Container(
                                                        margin: EdgeInsets.only(left: width * 0.03),
                                                        child: Text(getTranslated(context, home_click_here).toString(),
                                                            style: TextStyle(fontSize: 16, color: purple)))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    color: tabBar,
                                    width: width * 1.0,
                                    child: Container(
                                      height: height * 0.05,
                                      margin: EdgeInsets.only(left: width * 0.06, right: width * 0.08),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getTranslated(context, home_title).toString(),
                                            style: TextStyle(fontSize: 18, color: hintColor),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.pushNamed(context, "ViewAllAppointment"),
                                            child: todayappointmentsreq.length < 5
                                                ? Container()
                                                : Container(
                                                    child: Text(
                                                      getTranslated(context, home_show_all).toString(),
                                                      style: TextStyle(fontSize: width * 0.035, color: loginButton),
                                                    ),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  todayappointmentsreq.length == 0
                                      ? Center(
                                          child: Container(
                                            margin: EdgeInsets.only(top: height * 0.2),
                                            child: Container(
                                              child: Image.asset("assets/images/no-data.png"),
                                            ),
                                          ),
                                        )
                                      : _search.text.isNotEmpty
                                          ? _searchResult.length > 0
                                              ? ListView.builder(
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
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                PatientInformationScreen(id: _searchResult[i].id)));
                                                                  },
                                                                  child: Card(
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(15.0),
                                                                      ),
                                                                      child: Column(children: <Widget>[
                                                                        Container(
                                                                          child: ListTile(
                                                                            isThreeLine: true,
                                                                            leading: SizedBox(
                                                                              height: height * 0.20,
                                                                              width: width * 0.15,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                child: Container(
                                                                                    decoration: new BoxDecoration(
                                                                                        image: new DecorationImage(
                                                                                            fit: BoxFit.fitHeight,
                                                                                            image: NetworkImage(
                                                                                                _searchResult[i].user!.fullImage!)))),
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
                                                                              SharedPreferenceHelper.getString(
                                                                                      Preferences.currency_symbol) +
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
                                                                                  alignment: AlignmentDirectional.topStart,
                                                                                  child: Text(
                                                                                    _searchResult[i].patientAddress!,
                                                                                    style:
                                                                                        TextStyle(fontSize: 12, color: passwordVisibility),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 2,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ])),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  height: height / 1.5,
                                                  child: Center(
                                                      child: Container(child: Text(getTranslated(context, result_not_found).toString()))))
                                          : ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: 5 < todayappointmentsreq.length ? 5 : todayappointmentsreq.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(left: width * 0.06, right: width * 0.02),
                                                          child: Text(
                                                            todayappointmentsreq[index].time!,
                                                            style: TextStyle(fontSize: 16, color: passwordVisibility),
                                                          ),
                                                        ),
                                                        Container(
                                                            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                                                            height: 100,
                                                            width: width * 0.70,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            PatientInformationScreen(id: todayappointmentsreq[index].id)));
                                                              },
                                                              child: Card(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                  ),
                                                                  child: Column(children: <Widget>[
                                                                    Container(
                                                                      child: ListTile(
                                                                        isThreeLine: true,
                                                                        leading: SizedBox(
                                                                          height: height * 0.20,
                                                                          width: width * 0.15,
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            child: Container(
                                                                                decoration: new BoxDecoration(
                                                                                    image: new DecorationImage(
                                                                                        fit: BoxFit.fitHeight,
                                                                                        image: NetworkImage(todayappointmentsreq[index]
                                                                                            .user!
                                                                                            .fullImage!)))),
                                                                          ),
                                                                        ),
                                                                        title: Container(
                                                                          alignment: AlignmentDirectional.topStart,
                                                                          margin: EdgeInsets.only(
                                                                            top: height * 0.01,
                                                                          ),
                                                                          child: Text(todayappointmentsreq[index].patientName!,
                                                                              style: TextStyle(fontSize: 16.0)),
                                                                        ),
                                                                        trailing: Container(
                                                                            child: Text(
                                                                          SharedPreferenceHelper.getString(Preferences.currency_symbol) +
                                                                              todayappointmentsreq[index].amount.toString(),
                                                                          style: TextStyle(fontSize: 16, color: hintColor),
                                                                        )),
                                                                        subtitle: Column(
                                                                          children: <Widget>[
                                                                            Container(
                                                                                alignment: AlignmentDirectional.topStart,
                                                                                child: Text(
                                                                                  getTranslated(context, home_age_data).toString() +
                                                                                      ":" +
                                                                                      todayappointmentsreq[index].age.toString(),
                                                                                  style: TextStyle(fontSize: 12, color: hintColor),
                                                                                )),
                                                                            Container(
                                                                              alignment: AlignmentDirectional.topStart,
                                                                              child: Text(
                                                                                todayappointmentsreq[index].patientAddress!,
                                                                                style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ])),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
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
      ),
    );
  }

  Future<BaseModel<TodaysAppointment>> todayappointmentsFunction() async {
    TodaysAppointment response;
    try {
      todayappointmentsreq.clear();
      _todayUserAppointment.clear();
      response = (await RestClient(RetroApi().dioData()).todayappointments());
      setState(() {
        todayappointmentsreq.addAll(response.data!);
        _todayUserAppointment.addAll(response.data!);
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

  Future<void> logoutUser() async {
    SharedPreferenceHelper.clearPref();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SignIn()),
      ModalRoute.withName('SignIn'),
    );
  }

  Widget dialog() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.1),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1.0),
        borderRadius: BorderRadius.circular(40),
      ),
      width: width * 0.8,
      child: Container(
        height: 280,
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: width * 0.15,
                child: SizedBox.expand(
                  child: Image.asset(
                    'assets/images/alert.png',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: Text(
                getTranslated(context, home_subscription_deactive).toString(),
                style: TextStyle(fontSize: 20, color: hintColor, decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              )),
              GestureDetector(
                onTap: () {
                  SubScription();
                },
                child: Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    child: Text(
                      getTranslated(context, home_please_active_plan).toString(),
                      style: TextStyle(fontSize: 14, color: darkGrey, decoration: TextDecoration.none),
                      textAlign: TextAlign.center,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, "subscription"),
                      child: Text(getTranslated(context, home_activate_subscription).toString())))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getOneSingleToken() async {
    try {
      OneSignal.shared.setNotificationOpenedHandler((event) {
        print("id ${event.notification.additionalData}  ${event.notification.additionalData!["id"]}");
        if (event.action!.actionId == "") {
        } else if (event.action!.actionId == "decline") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCall(
                callEnd: true,
                userId: event.notification.additionalData!["id"],
              ),
            ),
          );
        } else if (event.action!.actionId == "accept") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCall(
                callEnd: false,
                userId: event.notification.additionalData!["id"],
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PhoneScreen(event.notification.additionalData)),
          );
        }
      });
    } catch (e) {}
  }

  showAlertDialog(BuildContext context) {
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

    AlertDialog alert = AlertDialog(
      content: Text(getTranslated(context, are_you_sure_logout).toString()),
      actions: [cancel, okButton],
    );
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

    _todayUserAppointment.forEach((appointmentData) {
      if (appointmentData.patientName!.toLowerCase().contains(text.toLowerCase())) _searchResult.add(appointmentData);
    });

    setState(() {});
  }
}
