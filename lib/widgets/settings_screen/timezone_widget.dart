import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/screen/timezone_list.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';

class TimeZoneWidget extends StatefulWidget {
  @override
  _TimeZoneWidgetState createState() => _TimeZoneWidgetState();
}

class _TimeZoneWidgetState extends State<TimeZoneWidget> {
  String timeZoneName;

  @override
  void initState() {
    _setupTimezone();
    super.initState();
  }

  _setupTimezone() {
    setState(() {
      timeZoneName = "(" + prefsHelper.getTimeZone() + ")";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(TimeZoneScreen.ROUTE_NAME,
            arguments: TimeZoneScreenArguments(() {
          _setupTimezone();
        }));
      },
      leading: Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Icon(
          Icons.place_outlined,
          color: ColorConstants.primaryColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.black38,
        size: 20,
      ),
      title: Text(
        S.of(context).timezone,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.black87),
      ),
      subtitle: Text(
        timeZoneName,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.0,
            color: ColorConstants.primaryColor),
      ),
    );
  }
}
