import 'package:dating/Screens/video_call_screen/widgets/widgets.dart';
import 'package:dating/shared/video_call_config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key key}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int _remoteId;
  RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initForAgora();
  }

  Future<void> initForAgora() async {
    //Requesting for permission
    await [Permission.microphone, Permission.camera].request();

    //Creating agora engine
    _engine = await RtcEngine.create(VideoCallConfig.appId);

    //Enable for video
    await _engine.enableVideo();

    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("Local user $uid joined");
        },
        userJoined: (int uid, int elapsed) {
          print("Remote user $uid joined");
          setState(() {
            _remoteId = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("Remote user $uid left channel");
          setState(() {
            _remoteId = null;
          });
        },
      ),
    );

    await _engine.joinChannel(VideoCallConfig.token, 'test', null, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _renderRemoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 130,
              child: Center(
                child: _renderLocalVideo(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Render current user local video
  Widget _renderLocalVideo() {
    return RtcLocalView.SurfaceView();
  }

  //Render remote user video
  Widget _renderRemoteVideo() {
    if (_remoteId != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteId,
      );
    } else {
      return WaitingPage();
    }
  }
}
