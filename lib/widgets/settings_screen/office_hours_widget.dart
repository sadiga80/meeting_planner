import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/model/office_hours.dart';
import 'package:meeting_planner/screen/office_hours.dart';
import 'package:meeting_planner/utils/common_util.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';

class OfficeHoursWidget extends StatefulWidget {
  @override
  _OfficeHoursWidgetState createState() => _OfficeHoursWidgetState();
}

class _OfficeHoursWidgetState extends State<OfficeHoursWidget> {
  OfficeHours officeHours;
  String officeHoursString = "";

  @override
  void initState() {
    setOfficeHours();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(OfficeHoursScreen.ROUTE_NAME,
            arguments: OfficeHoursScreenArguments(() {
              setOfficeHours();
            }, officeHours));
      },
      leading: Container(
          margin: EdgeInsets.only(top: 8),
          child: Icon(
            Icons.access_time,
            color: ColorConstants.primaryColor,
          )),
      title: Text(
        S.of(context).office_hours,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.black87),
      ),
      subtitle: Text(
        officeHoursString,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.0,
            color: ColorConstants.primaryColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.black38,
        size: 20,
      ),
    );
  }

  setOfficeHours() {
    String officeHoursData = prefsHelper.getOfficeHours();
    officeHours = OfficeHours.fromJson(json.decode(officeHoursData));
    String startTimeString = CommonUtil.instance
        .convertTo_hhmm(DateTime.parse(officeHours.startTime));
    String closingTimeString = CommonUtil.instance
        .convertTo_hhmm(DateTime.parse(officeHours.closingTime));
    setState(() {
      officeHoursString =
          "(" + startTimeString + " - " + closingTimeString + ")";
    });
  }
}
