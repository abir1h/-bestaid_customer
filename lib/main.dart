import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'Screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.shared.init(
    "b4c18fe3-39a5-4e0d-9b16-ba4a8d130df7",
    iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false,
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Best Aid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
