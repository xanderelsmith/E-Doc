import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../../../authentication/data/models/user.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';

const appId = "6e87b4249eb240e8a63b46ca4e4efd83";

class CallScreen extends StatefulWidget {
  static String id = 'CallScreenAGora';
  const CallScreen(
      {super.key,
      required this.otheruser,
      this.callId,
      required this.sendMessage,
      required this.isVideoCall,
      required this.endCall});
  final bool isVideoCall;

  ///call is only used by clients to join a preexisting call since they initiate start one
  final String? callId;
  final CustomUserData otheruser;
  final Function(String) sendMessage;
  final Function(String) endCall;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid;
  final int _myUid = 0;
  String channel = "test";
  String token = '';

  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool isLoudScreen = false;
  bool isVideoScreen = false;
  bool isMuted = false;

  int secondsElapsed = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();

    isVideoScreen = widget.isVideoCall;
    initAgora();
    _startTimer();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_localUserJoined == true && _remoteUid != null) {
          secondsElapsed++;
        }
      });
    });
  }

  Future<void> initAgora() async {
    // retrieve permissions
    log(widget.callId.toString());
    if (widget.callId != null) {
      token = widget.callId!;
      log('Presnt');
    } else {
      log(token);
      log('absent');
      token = await getToken(_myUid, channel);
    }

    log(token.toString());
    widget.sendMessage(token);
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      //channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
            log(_remoteUid.toString());
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    if (isVideoScreen) {
      await _engine.enableVideo();
      await _engine.startPreview();
    } else {
      await _engine.enableAudio();
    }

    await _engine.joinChannel(
        token: token,
        channelId: channel,
        uid: _myUid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ));
  }

  @override
  void dispose() {
    timer?.cancel();
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, isVideoScreen ? -0.9 : 0.9),
            child: Center(
              child: _remoteVideo(),
            ),
          ),
          Align(
            alignment:
                Alignment(isVideoScreen ? 0.8 : 0, isVideoScreen ? -0.9 : 0),
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: isVideoScreen
                    ? _localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const CircularProgressIndicator()
                    : CachedNetworkImage(
                        imageUrl: widget.otheruser.profileImageUrl ?? ''),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: Size(getScreenSize(context).width - 80, 20),
              ),
              onPressed: () {
                widget.endCall(token);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.call,
              ),
              label: const Text('End Call'),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.7),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3B3B3B5E),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10)))),
                child: Icon(
                  Icons.volume_up,
                  color: isLoudScreen ? Colors.white : Colors.black,
                ),
                onPressed: () async {
                  isLoudScreen = await _engine.isSpeakerphoneEnabled();
                  isLoudScreen =
                      isLoudScreen == true ? isLoudScreen : isLoudScreen;
                  _engine.setEnableSpeakerphone(isLoudScreen);

                  setState(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3B3B3B5E),
                      shape: const RoundedRectangleBorder()),
                  child: Icon(
                    isVideoScreen ? Icons.videocam : Icons.videocam_off,
                    color: isVideoScreen ? Colors.white : Colors.black,
                  ),
                  onPressed: () async {
                    isVideoScreen = isVideoScreen == true ? false : true;
                    await _engine.muteLocalVideoStream(!isVideoScreen);
                    if (isVideoScreen == true) {
                      await _engine.enableVideo();
                      await _engine.startPreview();
                    }
                    setState(() {});
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3b3b3b5e),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(10)))),
                child: Icon(
                  isMuted ? Icons.mic_none_sharp : Icons.mic_off_outlined,
                  color: !isMuted ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isMuted = isMuted == true ? false : true;
                    _engine.muteLocalAudioStream(isMuted);
                  });
                },
              )
            ]),
          ),
          if (_localUserJoined && _remoteUid == null)
            Align(
              alignment: const Alignment(0, 0.5),
              child: Text(
                _remoteUid != null
                    ? _formatDuration(Duration(seconds: secondsElapsed))
                    : 'waiting for user',
                style: const TextStyle(fontSize: 19),
              ),
            ),
          !_localUserJoined
              ? Dialog(
                  child: SizedBox(
                    height: 100,
                    child: Column(children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            widget.callId != null
                                ? 'Joining Call, please wait'
                                : 'Preparing Call, please wait',
                            style: const TextStyle(fontSize: 20)),
                      )),
                      const Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(),
                      ))
                    ]),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return isVideoScreen
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: _remoteUid),
                connection: RtcConnection(channelId: channel),
              ),
            )
          : const SizedBox();
    } else {
      return const SizedBox();
    }
  }
}

String _formatDuration(Duration duration) {
  return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}

Future<String> getToken(int myId, String channel) async {
  const String url =
      "https://agora-token-service-production-5192.up.railway.app/getToken";

  // Define the request headers and body
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  Map<String, dynamic> requestBody = {
    "tokenType": "rtc",
    "channel": channel,
    "role": "publisher",
    "uid": myId.toString(),
    "expire": 3600,
  };

  String jsonBody = convert.jsonEncode(requestBody);

  try {
    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // Request successful, parse the response JSON
      Map<String, dynamic> data = convert.jsonDecode(response.body);
      String token = data["token"];
      log(token);
      return token;
    } else {
      // Request failed
      print("Failed to get token. Status code: ${response.statusCode}");
      return ''; // or throw an exception
    }
  } catch (e) {
    // Handle network or other errors
    print("Error: $e");
    return ''; // or throw an exception
  }
}
