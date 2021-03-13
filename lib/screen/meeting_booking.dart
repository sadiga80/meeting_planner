import 'package:flutter/material.dart';
import 'package:meeting_planner/datasource/home/home_datasource.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/model/booking.dart';
import 'package:meeting_planner/utils/common_util.dart';
import 'package:meeting_planner/widgets/booking_screen/choose_meeting_widget.dart';
import 'package:meeting_planner/widgets/booking_screen/description_widget.dart';
import 'package:meeting_planner/widgets/booking_screen/meeting_duration_widget.dart';
import 'package:meeting_planner/widgets/booking_screen/meeting_time.dart';
import 'package:meeting_planner/widgets/booking_screen/priority_widget.dart';
import 'package:meeting_planner/widgets/booking_screen/reminder.dart';
import 'package:meeting_planner/widgets/booking_screen/title_widget.dart';
import 'package:meeting_planner/widgets/common_widget.dart';
import 'package:meeting_planner/widgets/custom_button.dart';

class MeetingBookingScreen extends StatefulWidget {
  static const ROUTE_NAME = "/home/plan_meeting_screen";

  MeetingBookingScreenArguments arguments;

  MeetingBookingScreen(this.arguments);

  @override
  _MeetingBookingScreenState createState() => _MeetingBookingScreenState();
}

class _MeetingBookingScreenState extends State<MeetingBookingScreen>
    with CommonWidget {
  TextEditingController _titleController, _descriptionController;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false, isReminder = false, isEnabled = true;
  DateTime selectedDateTime;
  String roomName;
  int meetingDuration = 30, selectedReminderDuration = 15, priority;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.arguments.item != null) _setupData();
    super.initState();
  }

  _setupData() {
    BookingItem item = widget.arguments.item;
    isEnabled = false;
    _titleController.text = item.title;
    _descriptionController.text = item.description;
    selectedDateTime = DateTime.parse(item.dateTime);
    meetingDuration = item.meetingDuration;
    roomName = item.meetingRoom;
    priority = item.priority;
    isReminder = item.isReminder == 1;
    if (isReminder) selectedReminderDuration = item.reminderDuration;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: getAppBar(
          context,
          isEnabled
              ? S.of(context).book_meeting
              : S.of(context).meeting_details,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(_formKey, _titleController, _isSubmitted,
                              isEnabled),
                          SizedBox(
                            height: 20.0,
                          ),
                          DescriptionWidget(_formKey, _descriptionController,
                              _isSubmitted, isEnabled),
                          SizedBox(
                            height: 20.0,
                          ),
                          MeetingTimeWidget((selectedDateTime) {
                            this.selectedDateTime = selectedDateTime;
                          },
                              _isSubmitted,
                              selectedDateTime == null
                                  ? null
                                  : CommonUtil.instance
                                      .convertTo_dd_MMM_yyyy_hhmm(
                                          selectedDateTime)),
                          SizedBox(
                            height: 20.0,
                          ),
                          MeetingDurationWidget((meetingDuration) {
                            this.meetingDuration = meetingDuration;
                          }, !isEnabled ? meetingDuration : null),
                          SizedBox(
                            height: 20.0,
                          ),
                          ChooseMeetingWidget((roomName) {
                            this.roomName = roomName;
                          }, _isSubmitted, roomName),
                          SizedBox(
                            height: 20.0,
                          ),
                          PriorityWidget((priority) {
                            this.priority = priority;
                          }, _isSubmitted, !isEnabled ? priority : null),
                          SizedBox(
                            height: 10.0,
                          ),
                          ReminderWidget(
                              (isReminder, selectedReminderDuration) {
                            this.isReminder = isReminder;
                            this.selectedReminderDuration =
                                selectedReminderDuration;
                          },
                              _isSubmitted,
                              !isEnabled
                                  ? (isReminder
                                      ? selectedReminderDuration
                                      : null)
                                  : null,
                              isEnabled),
                          SizedBox(
                            height: 60.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.arguments.item?.isCancelled != 1)
                CustomButton(() {
                  if (widget.arguments.item == null) {
                    setState(() {
                      _isSubmitted = true;
                    });
                    if (_formKey.currentState.validate() &&
                        selectedDateTime != null &&
                        roomName != null &&
                        priority != null) {
                      _onBooking();
                    }
                  } else {
                    widget.arguments.item.isCancelled = 1;
                    widget.arguments.homeDataSource
                        .updateData(widget.arguments.item);
                    widget.arguments.onPlanMeeting();
                    Navigator.of(context).pop();
                  }
                },
                    widget.arguments.item == null
                        ? S.of(context).book_title.toUpperCase()
                        : S.of(context).cancel_booking.toUpperCase())
            ],
          ),
        ),
      ),
    );
  }

  _onBooking() {
    BookingItem bookingItem = BookingItem();
    bookingItem.title = _titleController.text;
    bookingItem.description = _descriptionController.text;
    bookingItem.dateTime = selectedDateTime.toIso8601String();
    bookingItem.meetingDuration = meetingDuration;
    bookingItem.meetingRoom = roomName;
    bookingItem.priority = priority;
    bookingItem.isReminder = isReminder ? 1 : 0;
    bookingItem.reminderDuration = selectedReminderDuration;

    print(bookingItem.toString());

    widget.arguments.homeDataSource.insertData(bookingItem);
    widget.arguments.onPlanMeeting();
    if (isReminder) {
      scheduleNotification(
          selectedReminderDuration, bookingItem.title, bookingItem.description);
    }
    Navigator.of(context).pop();
  }
}

class MeetingBookingScreenArguments {
  Function() onPlanMeeting;
  HomeDataSource homeDataSource;
  BookingItem item;

  MeetingBookingScreenArguments(
      this.onPlanMeeting, this.homeDataSource, this.item);
}
