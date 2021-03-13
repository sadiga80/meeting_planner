import 'package:flutter/material.dart';
import 'package:meeting_planner/generated/l10n.dart';

import '../../color.dart';
import 'meeting_room_color_widget.dart';

class MeetingRoomSettingsWidget extends StatefulWidget {
  @override
  _MeetingRoomSettingsWidgetState createState() =>
      _MeetingRoomSettingsWidgetState();
}

class _MeetingRoomSettingsWidgetState extends State<MeetingRoomSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _showRoomSettingsAlertWidget();
      },
      leading: Icon(
        Icons.color_lens_outlined,
        color: ColorConstants.primaryColor,
      ),
      title: Text(
        S.of(context).meeting_rooms_color_code,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.black87),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.black38,
        size: 20,
      ),
    );
  }

  _showRoomSettingsAlertWidget() {
    //_setupData();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: MeetingRoomColorWidget(),
          );
        });
  }
}
