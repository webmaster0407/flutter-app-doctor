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
import 'package:doctro/model/review.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:doctro/screens/SignIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class RateAndReviewScreen extends StatefulWidget {
  @override
  _RateAndReviewScreenState createState() => _RateAndReviewScreenState();
}

class _RateAndReviewScreenState extends State<RateAndReviewScreen> {
  //Set Loader Data
  Future? reviewDatas;

  //Set Open Drawer
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Set Height/Width Using MediaQuery
  late double width;
  late double height;

  //doctorReview
  List<ReviewData> reviewData = [];

  //get preferences
  String? dname;

  String? dfullimg;

  String? phone;
  int? subscription;

  //Search view
  TextEditingController _search = TextEditingController();
  List<ReviewData> _searchResult = [];
  List<ReviewData> _userReview = [];

  //set HospitalName & HospitalAddress app bar
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
      dname = SharedPreferenceHelper.getString(Preferences.name);
      dfullimg = SharedPreferenceHelper.getString(Preferences.image);
      phone = SharedPreferenceHelper.getString(Preferences.phone_no);
      subscription = SharedPreferenceHelper.getInt(Preferences.subscription_status);
      reviewDatas = reviewrequset();
      doctorprofile();
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

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
                        imageUrl: '$dfullimg',
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
                            }  else if (_drawerMenu[index] == getTranslated(context, drawer_schedule_timing).toString()) {
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
                                  hintText: getTranslated(context, review_search).toString(),
                                  hintStyle: TextStyle(
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
        child: FutureBuilder(
            future: reviewDatas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                  onRefresh: reviewrequset,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08, top: height * 0.020),
                            child: Container(
                              child: Text(
                                getTranslated(context, review_heading).toString(),
                                style: TextStyle(fontSize: width * 0.05, color: hintColor),
                              ),
                            ),
                          ),
                          reviewData.length == 0
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
                                            String createDate = DateUtil().formattedDate(DateTime.parse(_searchResult[i].createdAt!));
                                            return Container(
                                                margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                                                width: width * 0.87,
                                                height: 100,
                                                child: Column(children: <Widget>[
                                                  Container(
                                                    child: ListTile(
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
                                                      title: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                            alignment: AlignmentDirectional.topStart,
                                                            margin: EdgeInsets.only(
                                                              top: height * 0.01,
                                                            ),
                                                            child: Text(_searchResult[i].user!.name!, style: TextStyle(fontSize: 16.0)),
                                                          ),
                                                          Container(
                                                            child: RatingBarIndicator(
                                                              rating: _searchResult[i].rate!.toDouble(),
                                                              itemBuilder: (context, index) => Icon(
                                                                Icons.star,
                                                                color: loginButton,
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 18.0,
                                                              direction: Axis.horizontal,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            alignment: AlignmentDirectional.topStart,
                                                            child: Text(
                                                              _searchResult[i].review!,
                                                              style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                          Container(
                                                              alignment: AlignmentDirectional.topStart,
                                                              child: Text(
                                                                "$createDate",
                                                                style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]));
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
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      reverse: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: reviewData.length,
                                      itemBuilder: (context, index) {
                                        String createDate = DateUtil().formattedDate(DateTime.parse(reviewData[index].createdAt!));
                                        return Container(
                                            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                                            width: width * 0.87,
                                            height: 100,
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
                                                                  image: NetworkImage(reviewData[index].user!.fullImage!)))),
                                                    ),
                                                  ),
                                                  title: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        alignment: AlignmentDirectional.topStart,
                                                        margin: EdgeInsets.only(
                                                          top: height * 0.01,
                                                        ),
                                                        child: Text(reviewData[index].user!.name!, style: TextStyle(fontSize: 16.0)),
                                                      ),
                                                      Container(
                                                        child: RatingBarIndicator(
                                                          rating: reviewData[index].rate!.toDouble(),
                                                          itemBuilder: (context, index) => Icon(
                                                            Icons.star,
                                                            color: loginButton,
                                                          ),
                                                          itemCount: 5,
                                                          itemSize: 18.0,
                                                          direction: Axis.horizontal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        alignment: AlignmentDirectional.topStart,
                                                        child: Text(
                                                          reviewData[index].review!,
                                                          style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Container(
                                                          alignment: AlignmentDirectional.topStart,
                                                          child: Text(
                                                            "$createDate",
                                                            style: TextStyle(fontSize: 12, color: passwordVisibility),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]));
                                      },
                                    ),
                        ],
                      ),
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
    );
  }

  Future<BaseModel<Review>> reviewrequset() async {
    Review response;
    try {
      reviewData.clear();
      _userReview.clear();
      response = await RestClient(RetroApi().dioData()).reviewrequest();
      setState(() {
        reviewData.addAll(response.data!);
        _userReview.addAll(response.data!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<void> logoutUser() async {
    SharedPreferenceHelper.clearPref();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => SignIn()), ModalRoute.withName('SignIn'));
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

    _userReview.forEach((userName) {
      if (userName.user!.name!.toLowerCase().contains(text.toLowerCase())) _searchResult.add(userName);
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
