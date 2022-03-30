import 'package:doctro/VideoCall/overlay_handler.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/doctor_profile.dart';
import 'package:doctro/model/settings.dart';
import 'package:doctro/model/video_call_history_add_model.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:pip_view/pip_view.dart';
import 'loginhome.dart';

class VideoCall extends StatefulWidget {
  bool callEnd;
  int? userId;

  VideoCall({
    required this.callEnd,this.userId
});
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool muted = false;
  bool mutedVideo = false;
  late RtcEngine _engine;
  String? appId;
  String? token;
  String? channelName;
  int? doctorId = 0;


  int? callDuration = 0;
  String? callTime = "";
  String? callDate = "";

  @override
  void initState() {
    super.initState();
    settingrequest();
    offset = const Offset(20.0, 50.0);
  }

  Offset offset = Offset.zero;
  int? boxNumberIsDragged;

  Widget _toolbar() {
    return Consumer<OverlayHandlerProvider>(
      builder: (context, overlayProvider, _) {
        return Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(vertical: overlayProvider.inPipMode == true ? 20 : 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: muted ? colorWhite : loginButton,
                    size: overlayProvider.inPipMode == true ? 12.0 : 15.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? loginButton : colorWhite,
                  padding: EdgeInsets.all(overlayProvider.inPipMode == true ? 5.0 : 12.0),
                ),
              ),
              Expanded(
                child: RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  child: Icon(
                    Icons.call_end,
                    color: colorWhite,
                    size: overlayProvider.inPipMode == true ? 15.0 : 30.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: red,
                  padding: EdgeInsets.all(overlayProvider.inPipMode == true ? 5.0 : 15.0),
                ),
              ),
              Expanded(
                child: RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  child: Icon(
                    Icons.switch_camera,
                    color: loginButton,
                    size: overlayProvider.inPipMode == true ? 12.0 : 15.0,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: colorWhite,
                  padding: EdgeInsets.all(overlayProvider.inPipMode == true ? 5.0 : 12.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCallEnd(BuildContext context) {
    _engine.leaveChannel();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = await RtcEngine.create(appId!);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          setState(() {
            _remoteUid = uid;
            DateTime now = DateTime.now();
            callTime = DateFormat('h:mm a').format(now);
            callDate = DateFormat('yyyy-MM-dd').format(now);
            if(widget.callEnd == true){
              _engine.leaveChannel();
            }
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          setState(() {
            _remoteUid = null;
            _engine.leaveChannel();
          });
        },
        leaveChannel: (RtcStats detail) {
          setState(() {
            callDuration = detail.duration;
            if (callTime != "" && callDate != "" && widget.callEnd == false) {
              callApiAddVideoCallHistory();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginHome()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginHome()),
              );
            }
          });
        },
      ),
    );
    await _engine.joinChannel(token, channelName!, null, 0);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return PIPView(
      builder: (context, isFloating) {
        return Scaffold(
          body: Consumer<OverlayHandlerProvider>(
            builder: (context, overlayProvider, _) {
              return InkWell(
                onTap: () {
                  Provider.of<OverlayHandlerProvider>(context, listen: false).disablePip();
                },
                child: Stack(
                  children: [
                    Container(
                      color:grey,
                      child: Center(
                        child: _remoteVideo(),
                      ),
                    ),
                    widget.callEnd == true ? Container() :
                    Stack(
                      children: [
                        Positioned(
                          left: offset.dx,
                          top: offset.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                if (offset.dx > 0.0 && (offset.dx + 150) < width && offset.dy > 0.0 && (offset.dy + 200) < height) {
                                  offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                                } else {
                                  offset = Offset(details.delta.dx + 20, details.delta.dy + 50);
                                }
                              });
                            },
                            child: Consumer<OverlayHandlerProvider>(
                              builder: (context, overlayProvider, _) {
                                return SizedBox(
                                  width: overlayProvider.inPipMode == true ? 80 : 150,
                                  height: overlayProvider.inPipMode == true ? 80 : 200,
                                  child: Center(
                                    child: _localUserJoined
                                        ? RtcLocalView.SurfaceView(
                                            renderMode: VideoRenderMode.FILL,
                                          )
                                        : const CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    _toolbar(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<BaseModel<Doctorprofile>> doctorprofile() async {
    Doctorprofile response;
    try {
      response = await RestClient(RetroApi().dioData()).doctorprofile();

      setState(() {
        token = response.data!.agoraToken;
        channelName = response.data!.channelName;
        doctorId = response.data!.id;
        initAgora();
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Setting>> settingrequest() async {
    Setting response;
    try {
      response = await RestClient(RetroApi().dioData()).settingrequest();
      setState(() {
        appId = response.data!.agoraAppId;
        doctorprofile();
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<VideoCallHistoryAddModel>> callApiAddVideoCallHistory() async {
    VideoCallHistoryAddModel response;
    Map<String, dynamic> body = {
      "user_id": widget.userId,
      "date": callDate,
      "start_time": callTime,
      "duration": callDuration,
      "doctor_id": doctorId,
    };
    try {
      response = await RestClient(RetroApi().dioData()).videoCallHistoryAddRequest(body);

      setState(() {

      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid!);
    } else {
      return widget.callEnd == true ?
        ScalingText(
          getTranslated(context, disconnect_call).toString(),
        style: TextStyle(fontSize: 16, color: cardText),
      ) :  ScalingText(
          getTranslated(context, connect_call).toString(),
        style: TextStyle(fontSize: 16, color: cardText),
      );
    }
  }
}
