import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_planner/app.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';
import 'package:meeting_planner/widgets/common_widget.dart';
import 'package:timezone/data/latest.dart' as timezone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorConstants.primaryColor, // status bar color
    statusBarBrightness: Brightness.light, //status bar brigtness
    statusBarIconBrightness: Brightness.light, //status barIcon Brightness
  ));
  await SharedPrefsHelper().initialize();
  timezone.initializeTimeZones();
  CommonWidget.initializePlatformSpecifics();
  runApp(App());
}
