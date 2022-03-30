import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/video_call_history_show_model.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'SubscriptionHistory.dart';

class VideoCallHistory extends StatefulWidget {
  const VideoCallHistory({Key? key}) : super(key: key);

  @override
  _VideoCallHistoryState createState() => _VideoCallHistoryState();
}

class _VideoCallHistoryState extends State<VideoCallHistory> {

  bool loading = false;
  List<Data> callHistory = [];
  String duration = "";
  Future? loader;

  @override
  void initState() {
    super.initState();
    loader = callApiShowVideoCallHistory();
  }

  @override
  Widget build(BuildContext context) {

    double width;
    double height;

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: hintColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: colorWhite,
        title: Text(
          getTranslated(context, drawer_callHistory).toString(),
          style: TextStyle(fontSize: 18, color: hintColor, fontWeight: FontWeight.bold),
        ),
      ),
      body:
          FutureBuilder(
        future: loader,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return callHistory.length != 0
                ? ListView.builder(
                    itemCount: callHistory.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final now = Duration(seconds: int.parse(callHistory[index].duration!));
                      String _printDuration(Duration duration) {
                        String twoDigits(int n) => n.toString().padLeft(2, "0");
                        String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                        return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
                      }

                      // DurationTime split //
                      String str;
                      List<String> parts;
                      String minuteType;
                      String secondType;
                      String hourPart;
                      str = _printDuration(now);
                      parts = str.split(":");
                      hourPart = parts[0].trim();
                      minuteType = parts[1].trim();
                      secondType = parts[2].trim();

                      if (hourPart != "00" && minuteType != "00") {
                        duration = "${hourPart + "h " + minuteType + "m " + secondType + "s "}";
                        print("Time3 $duration");
                      } else if (hourPart == "00" && minuteType != "00") {
                        duration = "${minuteType + "m " + secondType + "s "}";
                        print("Time2 $duration ");
                      } else {
                        duration = "${secondType + "s "}";
                        print("Time1 $duration ");
                      }

                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: width * 0.02),
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.15,
                                  alignment: AlignmentDirectional.center,
                                  margin: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: width * 0.02),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: width * 0.15,
                                        height: height * 0.065,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            alignment: Alignment.center,
                                            imageUrl: callHistory[index].user!.fullImage!,
                                            fit: BoxFit.fitHeight,
                                            placeholder: (context, url) => const SpinKitFadingCircle(color: loginButton),
                                            errorWidget: (context, url, error) => ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Image.asset("assets/images/no_image.jpg"),
                                            ),
                                            width: width * 0.15,
                                            height: height * 0.065,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.8,
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                callHistory[index].user!.name!,
                                                style: TextStyle(fontSize: width * 0.04, color: hintColor, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                callHistory[index].startTime!.toLowerCase(),
                                                style: TextStyle(
                                                  fontSize: width * 0.03,
                                                  color: hintColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: AlignmentDirectional.topStart,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "$duration",
                                                style: TextStyle(
                                                  fontSize: width * 0.035,
                                                  color: hintColor,
                                                ),
                                              ),
                                              Text(
                                                DateUtil().formattedDate(DateTime.parse(callHistory[index].date!)),
                                                style: TextStyle(
                                                  fontSize: width * 0.035,
                                                  color: hintColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Column(
                              children: const [
                                DottedLine(
                                  direction: Axis.horizontal,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 3.0,
                                  dashColor: loginButton,
                                  dashRadius: 0.0,
                                  dashGapLength: 1.0,
                                  dashGapColor: transparent,
                                  dashGapRadius: 0.0,
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Center(
                    child: Image.asset("assets/images/no-data.png"),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<BaseModel<VideoCallHistoryShowModel>> callApiShowVideoCallHistory() async {
    VideoCallHistoryShowModel response;
    setState(() {
      loading = true;
    });
    try {
      response = await RestClient(RetroApi().dioData()).videoCallHistoryShowRequest();
      if (response.success == true) {
        setState(
          () {
            loading = false;
            callHistory.addAll(response.data!.reversed);
          },
        );
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
