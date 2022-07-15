import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import '../MainHome.dart';


class Meeting extends StatefulWidget{
  final String roomid;
  const Meeting({Key key,this.roomid}) : super(key: key);

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController();
  TextEditingController roomText = TextEditingController();
  final subjectText = TextEditingController(text: "Video Consultation");
  final nameText = TextEditingController(text: "User");
  final emailText = TextEditingController(text: "bestaid@gmail.com");
  final iosAppBarRGBAColor =
  TextEditingController(text: "#0080FF80"); //transparent blue
  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }
bool join=false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return
      WillPopScope(
        onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
          return false;
        },
        child : Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title:  Text('Best Aid Video Conferrence',style: GoogleFonts.lato(
                color: Color(0xff0E6B50),
                fontWeight: FontWeight.w800,
                fontSize: 18
            )),

          ),
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: kIsWeb
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.30,
                  child: meetConfig(),
                ),
                Container(
                    width: width * 0.60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          color: Colors.white54,
                          child: SizedBox(
                            width: width * 0.60 * 0.70,
                            height: width * 0.60 * 0.70,
                            child: JitsiMeetConferencing(
                              extraJS: [
                                // extraJs setup example
                                '<script>function echo(){console.log("echo!!!")};</script>',
                                '<script src="https://code.jquery.com/jquery-3.5.1.slim.js" integrity="sha256-DrT5NfxfbHvMHux31Lkhxg42LY6of8TaYyK50jnxRnM=" crossorigin="anonymous"></script>'
                              ],
                            ),
                          )),
                    ))
              ],
            )
                : meetConfig(),
          ),
        ),
      );

  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          Text("Welcome to Best Aid Video Chat",style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18
          )),
          SizedBox(
            height: 14.0,
          ),

         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Flexible(
               child: Text("Room ID : ",style: GoogleFonts.lato(
                   color: Color(0xff0E6B50),
                   fontWeight: FontWeight.w800,
                   fontSize: 18
               )),
             ),
             Flexible(
               child: Text(widget.roomid,style: GoogleFonts.lato(
               color: Colors.blue,
        fontWeight: FontWeight.w600,
        fontSize: 20
    )),
             ),
           ],
         ),
          CheckboxListTile(
            title: Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),

          Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _joinMeeting();
               Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
},
              child: Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue)),
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: widget.roomid)
      ..serverURL = serverUrl
      ..subject = subjectText.text
      ..userDisplayName = nameText.text
      ..userEmail = emailText.text
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": widget.roomid,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}