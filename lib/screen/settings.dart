import 'package:flutter/material.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';
import 'package:meeting_planner/widgets/common_widget.dart';
import 'package:meeting_planner/widgets/settings_screen/meeting_room_settings_widget.dart';
import 'package:meeting_planner/widgets/settings_screen/notification_settings.dart';
import 'package:meeting_planner/widgets/settings_screen/office_hours_widget.dart';
import 'package:meeting_planner/widgets/settings_screen/timezone_widget.dart';

class SettingsScreen extends StatefulWidget {
  static const ROUTE_NAME = "/home/settings_screen";

  SettingsScreenArguments arguments;

  SettingsScreen(this.arguments);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with CommonWidget {
  bool isNotifications;

  @override
  void initState() {
    isNotifications = prefsHelper.getNotificationStatus();
    super.initState();
  }

  Future<bool> _willPopScope() {
    widget.arguments.onUpdate();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        appBar: getAppBar(context, S.of(context).settings_title,
            onBackPressed: (from) {
          widget.arguments.onUpdate();
          Navigator.of(context).pop();
        }),
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  OfficeHoursWidget(),
                  Divider(),
                  MeetingRoomSettingsWidget(),
                  Divider(),
                  TimeZoneWidget(),
                  Divider(),
                  NotificationSettingsWidget(),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsScreenArguments {
  Function() onUpdate;
  SettingsScreenArguments(this.onUpdate);
}
