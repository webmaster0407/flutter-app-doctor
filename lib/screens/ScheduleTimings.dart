import 'dart:convert';
import 'package:doctro/model/UpdateTiming.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/working_hours.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScheduleTimings extends StatefulWidget {
  const ScheduleTimings({Key? key}) : super(key: key);

  @override
  _ScheduleTimingsState createState() => _ScheduleTimingsState();
}

//Set Value in Switch
bool isSwitched = true ;

//Check Status
int? checkStatus ;

List<Data> workingreq = [];
int passIndex = 0;
List startsTime = [];
List endsTime = [];

class _ScheduleTimingsState extends State<ScheduleTimings> {

  //Set Loader
  Future? workinghours;

  List<Map<String, dynamic>> listDynamic = [];

   @override
  void initState() {
    workinghours = doctorworkinghoursfunction();
    super.initState();
  }

  //Show Start & End Time List
  String? startTime;
  String? endTime;

  //Set Height/Width using MediaQuery
  late double width;
  late double height;

  int? id;

  //Set Value edit Button on Click to addMore
  String? _startTime;
  String? _endTime;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(20, 65),
          child: SafeArea(
              top: true,
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(
                      left: width * 0.06, right: width * 0.06, top: height * 0.02),
                  child: Row(
                    children: [
                      Container(
                          child: GestureDetector(
                            child: Icon(Icons.arrow_back_ios),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )),
                      Container(
                        margin: EdgeInsets.only(left: width /4.6),
                          child: Text(
                            getTranslated(context, schedule_heading).toString(),
                            style: TextStyle(fontSize: 20,color: hintColor),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
              ]))) ,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: workinghours,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
              }
              else {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                      getTranslated(context, schedule_schedule_title).toString(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            getTranslated(context, schedule_time_slot).toString(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            getTranslated(context, schedule_status).toString(),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height*0.02),
                        child: ListView.builder(
                            itemCount: workingreq.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              endsTime.clear();
                              startsTime.clear();
                              var parseData = json.decode(workingreq[index].periodList!);
                              for (int i = 0; i < parseData.length; i++) {
                                startsTime.add(parseData[i]['start_time']);
                                endsTime.add(parseData[i]['end_time']);
                              }
                              return Container(
                                // color: Colors.red,
                                child: Column(children: <Widget>[
                                  Container(
                                    child: ListTile(
                                      title: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              workingreq[index].dayIndex!,
                                            ),
                                          ),
                                          Spacer(),
                                          Expanded(
                                            flex: 8,
                                            child: ListView.builder(
                                                itemCount: startsTime.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    child: Row(
                                                      children: [
                                                        Text(startsTime[index]),
                                                        SizedBox(width: 2,),
                                                        Text(endsTime[index]),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                          // Spacer(),
                                          Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 25.0),
                                                child: IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () async {
                                                    passIndex = index;
                                                    id = workingreq[index].id;
                                                    checkStatus = workingreq[index].status;
                                                    var convertdata;
                                                    listDynamic.clear();
                                                    convertdata = json.decode(workingreq[index].periodList!);
                                                    startTime = convertdata[0]['start_time'];
                                                    endTime = convertdata[0]['end_time'];

                                                    TextEditingController startController = TextEditingController();
                                                    TextEditingController endtController = TextEditingController();

                                                    for (int k = 0; k < convertdata.length; k++) {
                                                      startController.text = convertdata[k]['start_time'];
                                                      endtController.text = convertdata[k]['end_time'];

                                                      listDynamic.add({
                                                        "start_time": startController.text,
                                                        "end_time": endtController.text,
                                                      });
                                                    }

                                                    showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                            builder: (context, myState) {
                                                              return AlertDialog(
                                                                insetPadding: EdgeInsets.all(10),
                                                                title: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(getTranslated(context, schedule_heading).toString()),
                                                                    SwitchScreen(checkStatus)
                                                                  ],
                                                                ),
                                                                content: Container(
                                                                  height: height * 0.3,
                                                                  width: width * 1.0,
                                                                  child: Column(
                                                                    children: [
                                                                      Flexible(
                                                                        child: ListView.builder(
                                                                          itemCount: listDynamic.length,
                                                                          itemBuilder: (context, index) {
                                                                            return Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    Text(
                                                                                    getTranslated(context, schedule_start_time).toString(),
                                                                                      style: TextStyle(fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      getTranslated(context, schedule_end_time).toString(),
                                                                                      style: TextStyle(fontSize: 18),
                                                                                    ),
                                                                                    SizedBox(),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    Container(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          List tempChange = [];
                                                                                          final TimeOfDay? result = await showTimePicker(
                                                                                              context: context,
                                                                                              initialTime: TimeOfDay.now(),
                                                                                              builder: (context, child) {
                                                                                                return MediaQuery(
                                                                                                    data: MediaQuery.of(context).copyWith(
                                                                                                      // Using 12-Hour format
                                                                                                        alwaysUse24HourFormat: false),
                                                                                                    // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                                                                    child: child!);
                                                                                              });
                                                                                          if (result != null) {
                                                                                            myState(() {
                                                                                              _startTime = result.format(context);
                                                                                              var decodeData =
                                                                                              json.decode(workingreq[passIndex].periodList!);
                                                                                              for (int i = 0; i < listDynamic.length; i++) {
                                                                                                tempChange.add(decodeData[i]);
                                                                                              }

                                                                                              tempChange[index] = {
                                                                                                "start_time": _startTime,
                                                                                                "end_time": listDynamic[index]["end_time"]
                                                                                              };

                                                                                              //change popup value
                                                                                              listDynamic[index] = {
                                                                                                "start_time": _startTime,
                                                                                                "end_time": listDynamic[index]["end_time"]
                                                                                              };
                                                                                            });
                                                                                          }
                                                                                          setState(() {
                                                                                            workingreq[passIndex].periodList =
                                                                                                JsonEncoder().convert(tempChange);
                                                                                          });
                                                                                        },
                                                                                        child: Card(
                                                                                          color: cardColor,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Container(
                                                                                            height: height * 0.07,
                                                                                            width: width * 0.30,
                                                                                            child: Container(
                                                                                              alignment: AlignmentDirectional.center,
                                                                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                              child:
                                                                                              Text(listDynamic[index]['start_time'].toString()),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          List tempChange = [];
                                                                                          final TimeOfDay? result = await showTimePicker(
                                                                                              context: context,
                                                                                              initialTime: TimeOfDay.now(),
                                                                                              builder: (context, child) {
                                                                                                return MediaQuery(
                                                                                                    data: MediaQuery.of(context).copyWith(
                                                                                                      // Using 12-Hour format
                                                                                                        alwaysUse24HourFormat: false),
                                                                                                    // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                                                                    child: child!);
                                                                                              });
                                                                                          if (result != null) {
                                                                                            myState(() {
                                                                                               _endTime = result.format(context);

                                                                                              var decodeData =
                                                                                              json.decode(workingreq[passIndex].periodList!);
                                                                                              for (int i = 0; i < listDynamic.length; i++) {
                                                                                                tempChange.add(decodeData[i]);
                                                                                              }

                                                                                              tempChange[index] = {
                                                                                                "start_time": listDynamic[index]["start_time"],
                                                                                                "end_time":  _endTime
                                                                                              };

                                                                                              listDynamic[index] = {
                                                                                                "start_time": listDynamic[index]["start_time"],
                                                                                                "end_time": _endTime
                                                                                              };
                                                                                            });
                                                                                          }
                                                                                          setState(() {
                                                                                            workingreq[passIndex].periodList =
                                                                                                JsonEncoder().convert(tempChange);
                                                                                          });
                                                                                        },
                                                                                        child: Card(
                                                                                          color: cardColor,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Container(
                                                                                            height: height * 0.07,
                                                                                            width: width * 0.30,
                                                                                            child: Container(
                                                                                              alignment: AlignmentDirectional.center,
                                                                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                              child:Text(listDynamic[index]['end_time'].toString()),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    index == 0  ?  Container() : InkWell(
                                                                                      child:Container(
                                                                                          margin: EdgeInsets.only(top: height*0.02),
                                                                                          child:Icon(Icons.delete)),
                                                                                      onTap: (){
                                                                                        myState(() {
                                                                                          listDynamic.removeAt(index);
                                                                                        });
                                                                                      },)
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                              margin: EdgeInsets.only(top: height * 0.02),
                                                                              height: 30,
                                                                              width: width * 0.09,
                                                                              padding: EdgeInsets.all(5),
                                                                              decoration: BoxDecoration(
                                                                                color: loginButton.withOpacity(0.4),
                                                                                borderRadius: BorderRadius.circular(50),
                                                                              ),
                                                                              child: Icon(Icons.add, size: 20, color: colorBlack)),
                                                                          GestureDetector(
                                                                            onTap: () {

                                                                              myState(() {
                                                                                listDynamic.add({
                                                                                  "start_time": getTranslated(context, schedule_start_time).toString(),
                                                                                  "end_time": getTranslated(context, schedule_end_time).toString(),
                                                                                });

                                                                                var decodeData = json.decode(workingreq[passIndex].periodList!);
                                                                                decodeData.add({
                                                                                  "start_time" : getTranslated(context, schedule_start_time).toString(),
                                                                                  "end_time" : getTranslated(context, schedule_end_time).toString(),

                                                                                });
                                                                                workingreq[passIndex].periodList = JsonEncoder().convert(decodeData);
                                                                              });
                                                                            },
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(top: width * 0.04, left: width * 0.02),
                                                                              child: Text(
                                                                                getTranslated(context, schedule_add_more).toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  color: hintColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  OutlinedButton(
                                                                    child: Text(getTranslated(context, schedule_ok_button).toString()),
                                                                    onPressed: () {
                                                                      bool isOk = true;

                                                                      for(int i =0 ; i<listDynamic.length;i++){
                                                                        if(listDynamic[i]['start_time'] == getTranslated(context, schedule_start_time).toString() || listDynamic[i]['end_time'] == getTranslated(context, schedule_end_time).toString()){
                                                                          isOk = false;
                                                                        }
                                                                      }

                                                                      if(isOk == true){
                                                                        myState(() {
                                                                          updatehours();
                                                                          Navigator.pop(context);
                                                                        });
                                                                      } else{
                                                                        Fluttertoast.showToast(
                                                                          msg: getTranslated(context, please_enter_start_end_time).toString(),
                                                                          toastLength: Toast.LENGTH_SHORT,
                                                                          gravity: ToastGravity.BOTTOM,
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        });
                                                  },
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: divider,
                                  ),
                                ]),
                              );
                            }),
                      )
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<BaseModel<Workinghours>> doctorworkinghoursfunction() async {

    Workinghours response;
    try {
      workingreq.clear();
      response = await RestClient(RetroApi().dioData()).workinghours();
      setState(() {
        workingreq.addAll(response.data!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<UpdateTiming>> updatehours() async {
    List hours = [];

    for (int i = 0; i < listDynamic.length; i++) {
      Map<String, dynamic> mapeducationdata = {
        "start_time": listDynamic[i]["start_time"].toString().toLowerCase(),
        "end_time": listDynamic[i]["end_time"].toString().toLowerCase(),
      };
      hours.add(mapeducationdata);
    }

    Map<String, dynamic> body = {
      "id": id.toString(),
      "period_list": hours,
      "status": isSwitched == true ? 1 : 0
    };
    UpdateTiming response;
    try {
      response = await RestClient(RetroApi().dioData()).updatetimingrequest(body);
      doctorworkinghoursfunction();
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

class SwitchScreen extends StatefulWidget {
  SwitchScreen(int? checkStatus);
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  @override
  void initState() {
    super.initState();
    if(checkStatus == 1){
      setState(() {
        isSwitched = true;
      });
    }else{
      setState(() {
        isSwitched = false;
      });
    }
  }

  void toggleSwitch(bool value) {

    if(isSwitched == true)
    {
      setState(() {
         isSwitched = false ;
      });
    }
    else
    {
      setState(() {
          isSwitched = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Row(
            children: [
              Container(child: Text(getTranslated(context, schedule_day_status).toString()),),
              Transform.scale(
                  scale: 1.2,
                  child: Switch(
                    onChanged: toggleSwitch,
                    value: isSwitched,
                    activeColor: colorWhite,
                    activeTrackColor: orange,
                    inactiveThumbColor: colorWhite,
                    inactiveTrackColor:red,
                  )
              ),
            ],
          ),
        ]);
  }
}