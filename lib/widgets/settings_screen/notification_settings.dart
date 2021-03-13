import 'package:flutter/material.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';

class NotificationSettingsWidget extends StatefulWidget {
  @override
  _NotificationSettingsWidgetState createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  bool isNotifications;

  @override
  void initState() {
    isNotifications = prefsHelper.getNotificationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.notifications_active,
        color: ColorConstants.primaryColor,
      ),
      title: Text(S.of(context).notifications_title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              color: Colors.black87)),
      trailing: Switch(
        value: isNotifications,
        onChanged: (value) {
          prefsHelper.setNotificationStatus(value);
          setState(() {
            isNotifications = value;
          });
        },
        activeTrackColor: ColorConstants.primaryLightColor,
        activeColor: ColorConstants.primaryColor,
      ),
    );
  }
}
