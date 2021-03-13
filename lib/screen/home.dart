import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/datasource/datasource.dart';
import 'package:meeting_planner/datasource/home/home_datasource.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/model/booking.dart';
import 'package:meeting_planner/model/office_hours.dart';
import 'package:meeting_planner/model/room.dart';
import 'package:meeting_planner/screen/meeting_booking.dart';
import 'package:meeting_planner/screen/settings.dart';
import 'package:meeting_planner/utils/common_util.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';
import 'package:meeting_planner/widgets/common_widget.dart';
import 'package:meeting_planner/widgets/home_screen/action_widgets.dart';
import 'package:meeting_planner/widgets/home_screen/meetings_list_widgets.dart';

import '../utils/string_constants.dart';

class HomeScreen extends StatelessWidget {
  static const ROUTE_NAME = "/home_screen";

  @override
  Widget build(BuildContext context) {
    return MeetingPlannerDataProvider(
        child: HomeScreenWidget(), dataSource: HomeDataSource());
  }
}

class HomeScreenWidget extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWidget> with CommonWidget {
  HomeDataSource homeDataSource;
  DateTime selectedDateTime, maxDateTime, minDateTime;
  bool isToday;

  @override
  void initState() {
    homeDataSource = MeetingPlannerDataProvider.of<HomeDataSource>(context);
    _setupInitialData();
    selectedDateTime = DateTime.now();
    maxDateTime = DateTime(selectedDateTime.year, selectedDateTime.month,
        selectedDateTime.day + 30);
    minDateTime = DateTime(selectedDateTime.year, selectedDateTime.month - 3,
        selectedDateTime.day);
    _getAllBookings(dateTime: selectedDateTime);
    super.initState();
  }

  _setupInitialData() {
    String meetingRoomDetails = prefsHelper.getMeetigRoomDetails();
    if (meetingRoomDetails == null) {
      List<RoomItem> rooms = [
        RoomItem(1, ColorConstants.roomA, "A"),
        RoomItem(2, ColorConstants.roomB, "B"),
        RoomItem(3, ColorConstants.roomC, "C"),
        RoomItem(4, ColorConstants.roomD, "D")
      ];
      String data = json.encode(MeetingRooms(meetingRooms: rooms));
      prefsHelper.setMeetigRoomDetails(data);

      DateTime currentTime = DateTime.now();

      DateTime officeStartTime =
          DateTime(currentTime.year, currentTime.month, currentTime.day, 9, 0);
      DateTime officeClosingTime =
          DateTime(currentTime.year, currentTime.month, currentTime.day, 17, 0);
      OfficeHours officeHours = OfficeHours();
      officeHours.startTime = officeStartTime.toIso8601String();
      officeHours.closingTime = officeClosingTime.toIso8601String();

      String officeHoursData = json.encode(officeHours);
      prefsHelper.setOfficeHours(officeHoursData);
      prefsHelper.setTimeZone(StringConstants.TIME_ZONE_DEFAULT);
    }
  }

  _getAllBookings({DateTime dateTime}) {
    homeDataSource.getAllBookings(dateTime: dateTime).then((data) {
      homeDataSource.changesSelectedDateTime(selectedDateTime);
      homeDataSource.changesBookings(data);
    });
  }

  Future<bool> _willPopScope() {
    return SystemNavigator.pop(animated: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        appBar: getAppBar(context, S.of(context).meetings_title,
            backActionRequired: false,
            isActionRequired: true,
            isCenterTitle: false, actionWidget: ActionWidgets((actionType) {
          switch (actionType) {
            case ActionType.calender:
              _datePicker();
              break;
            case ActionType.settings:
              Navigator.of(context).pushNamed(SettingsScreen.ROUTE_NAME,
                  arguments: SettingsScreenArguments(() {
                homeDataSource.changesBookings(homeDataSource.bookingsList);
              }));
              break;
          }
        })),
        body: MeetingsListWidget(homeDataSource, _onItemClick),
        floatingActionButton: !CommonUtil.instance.isPast(selectedDateTime)
            ? FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: ColorConstants.primaryColor,
                onPressed: () {
                  _onItemClick(null);
                },
              )
            : null,
      ),
    );
  }

  _onItemClick(BookingItem bookingItem) {
    Navigator.of(context).pushNamed(MeetingBookingScreen.ROUTE_NAME,
        arguments: MeetingBookingScreenArguments(() {
          _getAllBookings(dateTime: selectedDateTime);
        }, homeDataSource, bookingItem));
  }

  _datePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: minDateTime,
        maxTime: maxDateTime,
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        selectedDateTime = date;
      });
      _getAllBookings(dateTime: date);
    }, currentTime: selectedDateTime, locale: LocaleType.en);
  }
}
