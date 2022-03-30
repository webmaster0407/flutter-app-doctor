import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/model/appointmenthistory.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  @override
  _AppointmentHistoryScreen createState() => _AppointmentHistoryScreen();
}

class _AppointmentHistoryScreen extends State<AppointmentHistoryScreen> with TickerProviderStateMixin {
  //Set Loader
  Future? appointimenth;

  //Set Drawer Open
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Add List Data
  List<PastAppointment> pastappointmentreq = [];
  List<UpcomingAppointment> upcomingappointmentreq = [];

  //Search Patient
  TextEditingController _search = TextEditingController();
  List<UpcomingAppointment> _searchResult = [];
  List<UpcomingAppointment> _userDetails = [];
  List<PastAppointment> _pastSearch = [];
  List<PastAppointment> _pastdata = [];
  bool? isShow;

  //get preferences
  String? dname;

  String? dfullimage;

  String? phone;

  int? subscription;

  //Set Height/Width using MediaQuery
  late double width;
  late double height;

  //Set hospitalName and hospitalAddress appbar
  String? hospitalName, hospitalAddress;

  //Set Tabbar
  List<Tab> tabList = [];
  TabController? _tabController;

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
      tabList.add(new Tab(
        child: Text(
          getTranslated(context, upcoming_appointment).toString(),
          textAlign: TextAlign.center,
        ),
      ));
      tabList.add(new Tab(
        child: Text(
          getTranslated(context, past_appointment).toString(),
          textAlign: TextAlign.center,
        ),
      ));
      _tabController = new TabController(vsync: this, length: tabList.length);
      _tabController!.addListener(() {
        setState(() {
          if (isShow == null) {
            isShow = true;
            _searchResult.clear();
            _search.clear();
          } else {
            isShow = false;
            _pastSearch.clear();
            _search.clear();
          }
        });
      });

      appointimenth = appointmentHistoryScreen();
      dname = SharedPreferenceHelper.getString(Preferences.name);
      dfullimage = SharedPreferenceHelper.getString(Preferences.image);
      phone = SharedPreferenceHelper.getString(Preferences.phone_no);
      subscription = SharedPreferenceHelper.getInt(Preferences.subscription_status);
      doctorprofile();
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return Scaffold(
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
                                    }else if (_drawerMenu[index] == getTranslated(context, drawer_schedule_timing).toString()) {
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
                                          hintText: getTranslated(context, search_appointment_history).toString(),
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
              body: WillPopScope(
                onWillPop: () {
                  Navigator.pushNamedAndRemoveUntil(context, 'loginhome', (route) => false);
                  return Future<bool>.value(false);
                },
                child: RefreshIndicator(
                  onRefresh: appointmentHistoryScreen,
                  child: FutureBuilder(
                      future: appointimenth,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.02),
                                        child: Text(
                                          getTranslated(context, appointment_history_heading).toString(),
                                          style: TextStyle(fontSize: width * 0.05, color: hintColor),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        color: tabBar,
                                        padding: EdgeInsets.all(10),
                                        child: new TabBar(
                                          labelColor: loginButton,
                                          controller: _tabController,
                                          indicatorSize: TabBarIndicatorSize.tab,
                                          indicatorColor: loginButton,
                                          tabs: tabList,
                                          unselectedLabelColor: hintColor,
                                        ),
                                      ),
                                      Container(
                                        height: height / 1.5,
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: [
                                            upcomingappointmentreq.length == 0
                                                ? Container(
                                                    child: Center(
                                                      child: Image.asset("assets/images/no-data.png"),
                                                    ),
                                                  )
                                                : _search.text.isNotEmpty
                                                    ? _searchResult.length > 0
                                                        ? ListView.builder(
                                                            padding: EdgeInsets.only(bottom: 40),
                                                            scrollDirection: Axis.vertical,
                                                            shrinkWrap: true,
                                                            physics: AlwaysScrollableScrollPhysics(),
                                                            itemCount: _searchResult.length,
                                                            itemBuilder: (context, i) {
                                                              var statusColor = status;
                                                              if (_searchResult[i].appointmentStatus!.toUpperCase() ==
                                                                  getTranslated(context, status_pending).toString()) {
                                                                statusColor = hintColor.withOpacity(0.6);
                                                              } else if (_searchResult[i].appointmentStatus!.toUpperCase() ==
                                                                  getTranslated(context, status_cancel).toString()) {
                                                                statusColor = statusCancel;
                                                              } else if (_searchResult[i].appointmentStatus!.toUpperCase() ==
                                                                  getTranslated(context, status_approve).toString()) {
                                                                statusColor = status;
                                                              }
                                                              return Card(
                                                                  elevation: 2,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                  ),
                                                                  child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Container(
                                                                          child: ListTile(
                                                                            isThreeLine: true,
                                                                            leading: SizedBox(
                                                                              height: height * 0.15,
                                                                              width: width * 0.15,
                                                                              child: Image.network(_searchResult[i].user!.fullImage!),
                                                                            ),
                                                                            title: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(_searchResult[i].patientName!,
                                                                                    style: TextStyle(fontSize: 16.0)),
                                                                              ],
                                                                            ),
                                                                            trailing: Container(
                                                                              child: Text(
                                                                                _searchResult[i].appointmentStatus!.toUpperCase(),
                                                                                style: TextStyle(color: statusColor),
                                                                              ),
                                                                            ),
                                                                            subtitle: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  _searchResult[i].treatment!,
                                                                                  style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                                                ),
                                                                                Text(
                                                                                  _searchResult[i].patientAddress!,
                                                                                  style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color: divider,
                                                                        ),
                                                                        Container(
                                                                          margin: EdgeInsets.symmetric(horizontal: 20),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(getTranslated(context, date_and_time).toString(),
                                                                                      style: TextStyle(
                                                                                          fontSize: 14, color: passwordVisibility)),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(_searchResult[i].date!,
                                                                                          style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                      SizedBox(width: 5),
                                                                                      Text(_searchResult[i].time!,
                                                                                          style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(right: width * 0.02),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(getTranslated(context, doctor_name).toString(),
                                                                                        style: TextStyle(
                                                                                            fontSize: 14, color: passwordVisibility)),
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(),
                                                                                      child: Text(_searchResult[i].doctorName!,
                                                                                          style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ]));
                                                            },
                                                          )
                                                        : Center(
                                                            child: Container(
                                                            child: Text(getTranslated(context, result_not_found).toString()),
                                                          ))
                                                    : ListView.builder(
                                                        physics: AlwaysScrollableScrollPhysics(),
                                                        padding: EdgeInsets.only(bottom: 40),
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: upcomingappointmentreq.length,
                                                        itemBuilder: (context, index) {
                                                          var statusColor = status;
                                                          if (upcomingappointmentreq[index].appointmentStatus!.toUpperCase() ==
                                                              getTranslated(context, status_pending).toString()) {
                                                            statusColor = hintColor.withOpacity(0.6);
                                                          } else if (upcomingappointmentreq[index].appointmentStatus!.toUpperCase() ==
                                                              getTranslated(context, status_cancel).toString()) {
                                                            statusColor = statusCancel;
                                                          } else if (upcomingappointmentreq[index].appointmentStatus!.toUpperCase() ==
                                                              getTranslated(context, status_approve).toString()) {
                                                            statusColor = status;
                                                          }
                                                          //Set Date Formate dd-mm-yy
                                                          String date =
                                                              DateUtil().formattedDate(DateTime.parse(upcomingappointmentreq[index].date!));

                                                          return Container(
                                                              height: 160,
                                                              width: width * 0.87,
                                                              child: Card(
                                                                  elevation: 2,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                  ),
                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                                                                      Widget>[
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
                                                                                        image: NetworkImage(upcomingappointmentreq[index]
                                                                                            .user!
                                                                                            .fullImage!)))),
                                                                          ),
                                                                        ),
                                                                        title: Text(upcomingappointmentreq[index].patientName!,
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                        trailing: Container(
                                                                          child: Text(
                                                                            upcomingappointmentreq[index].appointmentStatus!.toUpperCase(),
                                                                            style: TextStyle(color: statusColor),
                                                                          ),
                                                                        ),
                                                                        subtitle: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              upcomingappointmentreq[index].treatment!,
                                                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                                            ),
                                                                            Text(
                                                                              upcomingappointmentreq[index].patientAddress!,
                                                                              style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      color: divider,
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(getTranslated(context, date_and_time).toString(),
                                                                                  style:
                                                                                      TextStyle(fontSize: 14, color: passwordVisibility)),
                                                                              Row(
                                                                                children: [
                                                                                  Text('$date',
                                                                                      style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                  SizedBox(width: 5),
                                                                                  Text(upcomingappointmentreq[index].time!,
                                                                                      style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            margin: EdgeInsets.only(right: width * 0.02),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Text(getTranslated(context, doctor_name).toString(),
                                                                                    style:
                                                                                        TextStyle(fontSize: 14, color: passwordVisibility)),
                                                                                Container(
                                                                                  margin: EdgeInsets.only(),
                                                                                  child: Text(upcomingappointmentreq[index].doctorName!,
                                                                                      style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ])));
                                                        },
                                                      ),
                                            pastappointmentreq.length == 0
                                                ? Container(
                                                    height: height / 2,
                                                    child: Image.asset("assets/images/no-data.png"),
                                                  )
                                                : _search.text.isNotEmpty
                                                    ? _pastSearch.length > 0
                                                        ? new ListView.builder(
                                                            padding: EdgeInsets.only(bottom: 40),
                                                            shrinkWrap: true,
                                                            itemCount: _pastSearch.length,
                                                            itemBuilder: (context, i) {
                                                              var statusColor = status;
                                                              if (_pastSearch[i].appointmentStatus!.toUpperCase() ==
                                                                  getTranslated(context, status_pending).toString()) {
                                                                statusColor = hintColor.withOpacity(0.6);
                                                              } else if (_pastSearch[i].appointmentStatus!.toUpperCase() ==
                                                                  getTranslated(context, status_cancel).toString()) {
                                                                statusColor = statusCancel;
                                                              } else if (_pastSearch[i].appointmentStatus!.toUpperCase() ==
                                                                  getTranslated(context, status_approve).toString()) {
                                                                statusColor = status;
                                                              }
                                                              return Container(
                                                                  height: 160,
                                                                  width: width * 0.87,
                                                                  child: Card(
                                                                      elevation: 2,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(15.0),
                                                                      ),
                                                                      child:
                                                                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                                                                              Widget>[
                                                                        Container(
                                                                          child: ListTile(
                                                                            isThreeLine: true,
                                                                            leading: SizedBox(
                                                                              height: height * 0.15,
                                                                              width: width * 0.15,
                                                                              child: Image.network(_pastSearch[i].user!.fullImage!),
                                                                            ),
                                                                            title: Text(_pastSearch[i].patientName!,
                                                                                style: TextStyle(fontSize: 16.0)),
                                                                            trailing: Container(
                                                                              child: Text(
                                                                                _pastSearch[i].appointmentStatus!.toUpperCase(),
                                                                                style: TextStyle(color: statusColor),
                                                                              ),
                                                                            ),
                                                                            subtitle: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  _pastSearch[i].treatment!,
                                                                                  style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                                                ),
                                                                                Text(
                                                                                  _pastSearch[i].patientAddress!,
                                                                                  style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color: divider,
                                                                        ),
                                                                        Container(
                                                                          margin: EdgeInsets.symmetric(horizontal: 20),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(getTranslated(context, date_and_time).toString(),
                                                                                      style: TextStyle(
                                                                                          fontSize: 14, color: passwordVisibility)),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(_pastSearch[i].date!,
                                                                                          style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(left: 5),
                                                                                        child: Text(_pastSearch[i].time!,
                                                                                            style:
                                                                                                TextStyle(fontSize: 14, color: hintColor)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(right: width * 0.02),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(getTranslated(context, doctor_name).toString(),
                                                                                        style: TextStyle(
                                                                                            fontSize: 14, color: passwordVisibility)),
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(),
                                                                                      child: Text(_pastSearch[i].doctorName!,
                                                                                          style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ])));
                                                            },
                                                          )
                                                        : Center(
                                                            child: Container(
                                                            child: Text(getTranslated(context, result_not_found).toString()),
                                                          ))
                                                    : ListView.builder(
                                                        physics: AlwaysScrollableScrollPhysics(),
                                                        padding: EdgeInsets.only(bottom: 40),
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: pastappointmentreq.length,
                                                        itemBuilder: (context, index) {
                                                          //Set Date Formate dd-mm-yy
                                                          String date =
                                                              DateUtil().formattedDate(DateTime.parse(pastappointmentreq[index].date!));
                                                          var statusColor = status;
                                                          if (pastappointmentreq[index].appointmentStatus!.toUpperCase() ==
                                                              getTranslated(context, status_pending).toString()) {
                                                            statusColor = hintColor.withOpacity(0.6);
                                                          } else if (pastappointmentreq[index].appointmentStatus!.toUpperCase() ==
                                                              getTranslated(context, status_cancel).toString()) {
                                                            statusColor = statusCancel;
                                                          } else if (pastappointmentreq[index].appointmentStatus!.toUpperCase() ==
                                                              getTranslated(context, status_approve).toString()) {
                                                            statusColor = status;
                                                          }
                                                          return Container(
                                                              height: 160,
                                                              width: width * 0.87,
                                                              child: Card(
                                                                  elevation: 2,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(15.0),
                                                                  ),
                                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                                                                      Widget>[
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
                                                                                    // shape: BoxShape.circle,
                                                                                    image: new DecorationImage(
                                                                                        fit: BoxFit.fitHeight,
                                                                                        image: NetworkImage(
                                                                                            pastappointmentreq[index].user!.fullImage!)))),
                                                                          ),
                                                                        ),
                                                                        title: Text(pastappointmentreq[index].patientName!,
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                        trailing: Container(
                                                                          child: Text(
                                                                            pastappointmentreq[index].appointmentStatus!.toUpperCase(),
                                                                            style: TextStyle(color: statusColor),
                                                                          ),
                                                                        ),
                                                                        subtitle: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              pastappointmentreq[index].treatment!,
                                                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                                            ),
                                                                            Text(
                                                                              pastappointmentreq[index].patientAddress!,
                                                                              style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      color: divider,
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(getTranslated(context, date_and_time).toString(),
                                                                                  style:
                                                                                      TextStyle(fontSize: 14, color: passwordVisibility)),
                                                                              Row(
                                                                                children: [
                                                                                  Text("$date",
                                                                                      style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                  Container(
                                                                                    margin: EdgeInsets.only(left: 5),
                                                                                    child: Text(pastappointmentreq[index].time!,
                                                                                        style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            margin: EdgeInsets.only(right: width * 0.02),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Text(getTranslated(context, doctor_name).toString(),
                                                                                    style:
                                                                                        TextStyle(fontSize: 14, color: passwordVisibility)),
                                                                                Container(
                                                                                  margin: EdgeInsets.only(),
                                                                                  child: Text(pastappointmentreq[index].doctorName!,
                                                                                      style: TextStyle(fontSize: 14, color: hintColor)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ])));
                                                        },
                                                      ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
          },
        );
      },
    );
  }

  Future<BaseModel<AppointmentHistory>> appointmentHistoryScreen() async {
    AppointmentHistory response;
    try {
      pastappointmentreq.clear();
      upcomingappointmentreq.clear();
      _pastdata.clear();
      _userDetails.clear();
      response = await RestClient(RetroApi().dioData()).appointmentHistoryScreenRequest();
      setState(() {
        pastappointmentreq.addAll(response.data!.pastAppointment!);
        upcomingappointmentreq.addAll(response.data!.upcomingAppointment!);
        _userDetails.addAll(response.data!.upcomingAppointment!);
        _pastdata.addAll(response.data!.pastAppointment!);
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
    _pastSearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    isShow == null
        ? _userDetails.forEach((upcomingAppointment) {
            if (upcomingAppointment.patientName!.toLowerCase().contains(text.toLowerCase())) _searchResult.add(upcomingAppointment);
          })
        : _pastdata.forEach((pastAppointment) {
            if (pastAppointment.patientName!.toLowerCase().contains(text.toLowerCase())) _pastSearch.add(pastAppointment);
          });

    setState(() {});
  }
}

class DateUtil {
  static const DATE_FORMAT = 'dd-MM-yyyy';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
