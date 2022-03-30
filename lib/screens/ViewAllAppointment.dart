import 'dart:async';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/today_appointment.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:doctro/screens/patient_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ViewAllAppointment extends StatefulWidget {

  @override
  _ViewAllAppointmentState createState() => _ViewAllAppointmentState();
}

class _ViewAllAppointmentState extends State<ViewAllAppointment> {

  //Set Height/Width Using MediaQuery
  late double width;
  late double height;

  //Set Loader
  Future? todayappointments;

  //Search Data
  TextEditingController _search = TextEditingController();
  List<Datas> _searchResult = [];

  //Add Data FirstTime List
  List<Datas> todayappointmentsreq = [];

  @override
  void initState() {
    super.initState();
    todayappointments = todayappointmentsFunction();
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

      return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(20, 150),
            child: SafeArea(
                top: true,
                child: Column(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.06, right: width * 0.04, top: height * 0.01),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            getTranslated(context, today_appointment_heading).toString(),
                              style:
                              TextStyle(fontSize: width * 0.05, color: hintColor),
                            ),
                            Container(
                              margin: EdgeInsets.only(),
                              child: IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                icon:  Icon(Icons.arrow_back_ios),
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
                                  controller:_search ,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: getTranslated(context, home_search_hint).toString(),
                                    hintStyle: TextStyle(
                                      fontSize: width * 0.045,
                                      color: hintColor.withOpacity(0.3),
                                    ),
                                  ),
                                  onChanged:
                                  onSearchTextChanged,
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
        body:  RefreshIndicator(
          onRefresh: todayappointmentsFunction,
          child: FutureBuilder(
              future: todayappointments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child:SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              color: divider,
                              width: width*1.0,
                              child: Container(
                                height: height*0.05,
                                margin: EdgeInsets.only(left: width*0.06,right: width*0.06),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, home_title).toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${todayappointmentsreq.length} " + getTranslated(context, today_appointment_length).toString(),
                                      style: TextStyle(
                                          fontSize: width * 0.035, color: loginButton),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _search.text.isNotEmpty ?_searchResult.length  > 0 ?
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _searchResult.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: width * 0.06),
                                          child: Text(
                                            _searchResult[i].time!,
                                            style: TextStyle(
                                                fontSize: 16, color: passwordVisibility),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.02, right: width * 0.02),
                                            height: 100,
                                            width: width * 0.70,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PatientInformationScreen(
                                                                id:_searchResult[i]
                                                                    .id)));
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
                                                                            _searchResult[i]
                                                                                .user!
                                                                                .fullImage!)))),
                                                          ),
                                                        ),
                                                        title: Container(
                                                          alignment:
                                                          AlignmentDirectional.topStart,
                                                          margin: EdgeInsets.only(
                                                            top: height * 0.01,
                                                          ),
                                                          child: Text(
                                                              _searchResult[i]
                                                                  .patientName!,
                                                              style: TextStyle(fontSize: 16.0)),
                                                        ),
                                                        trailing: Container(
                                                            child: Text(
                                                              SharedPreferenceHelper.getString(Preferences.currency_symbol) +
                                                                  _searchResult[i]
                                                                      .amount
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: hintColor),
                                                            )),
                                                        subtitle: Column(
                                                          children: <Widget>[
                                                            Container(
                                                                alignment: AlignmentDirectional
                                                                    .topStart,
                                                                child: Text(
                                                                  getTranslated(context, home_age_data).toString() +":" +
                                                                      _searchResult[
                                                                      i]
                                                                          .age
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      color: hintColor),
                                                                )),
                                                            Container(
                                                              alignment:
                                                              AlignmentDirectional.topStart,
                                                              child: Text(
                                                                _searchResult[i]
                                                                    .patientAddress!,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: passwordVisibility), overflow: TextOverflow.ellipsis,
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
                            ) : Container(
                                height: height / 1.5,
                                child: Center(child: Container(child: Text(getTranslated(context, result_not_found).toString())))):
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: todayappointmentsreq.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: width * 0.06),
                                          child: Text(
                                            todayappointmentsreq[index].time!,
                                            style: TextStyle(
                                                fontSize: 16, color: passwordVisibility),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.02, right: width * 0.02),
                                            height: 100,
                                            width: width * 0.70,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PatientInformationScreen(
                                                                id: todayappointmentsreq[index]
                                                                    .id)));
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
                                                                            todayappointmentsreq[index]
                                                                                .user!
                                                                                .fullImage!)))),
                                                          ),
                                                        ),
                                                        title: Container(
                                                          alignment:
                                                          AlignmentDirectional.topStart,
                                                          margin: EdgeInsets.only(
                                                            top: height * 0.01,
                                                          ),
                                                          child: Text(
                                                              todayappointmentsreq[index]
                                                                  .patientName!,
                                                              style: TextStyle(fontSize: 16.0)),
                                                        ),
                                                        trailing: Container(
                                                            child: Text(
                                                              SharedPreferenceHelper.getString(Preferences.currency_symbol) +
                                                                  todayappointmentsreq[index]
                                                                      .amount
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: hintColor),
                                                            )),
                                                        subtitle: Column(
                                                          children: <Widget>[
                                                            Container(
                                                                alignment: AlignmentDirectional
                                                                    .topStart,
                                                                child: Text(
                                                                  getTranslated(context, home_age_data).toString() +":" +
                                                                      todayappointmentsreq[
                                                                      index]
                                                                          .age
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      color: hintColor),
                                                                )),
                                                            Container(
                                                              alignment:
                                                              AlignmentDirectional.topStart,
                                                              child: Text(
                                                                todayappointmentsreq[index]
                                                                    .patientAddress!,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: passwordVisibility),overflow: TextOverflow.ellipsis,
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

  Future<BaseModel<TodaysAppointment>> todayappointmentsFunction() async {
    TodaysAppointment response;
    try {
      todayappointmentsreq.clear();
      response = (await RestClient(RetroApi().dioData()).todayappointments());
      setState(() {
        todayappointmentsreq.addAll(response.data!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));

    }
    return BaseModel()..data = response;
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    todayappointmentsreq.forEach((appointmentData) {
      if (appointmentData.patientName!.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(appointmentData);
    });

    setState(() {});
  }
}