import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/utils/common_util.dart';
import 'package:meeting_planner/utils/text_util.dart';

class MeetingTimeWidget extends StatefulWidget {
  Function(DateTime) onSelectDateTime;
  bool isSubmitted;
  String setValue;

  MeetingTimeWidget(this.onSelectDateTime, this.isSubmitted, this.setValue);

  @override
  _MeetingTimeWidgetState createState() => _MeetingTimeWidgetState();
}

class _MeetingTimeWidgetState extends State<MeetingTimeWidget> {
  String selectedDateTime;
  DateTime currentTime, selectedTime, maxDateTime, minDateTime;

  @override
  void initState() {
    currentTime = DateTime.now();
    if (widget.setValue != null) selectedDateTime = widget.setValue;
    minDateTime =
        DateTime.fromMicrosecondsSinceEpoch(currentTime.microsecondsSinceEpoch);
    maxDateTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day + 30,
        currentTime.hour,
        currentTime.minute,
        currentTime.second);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.setValue != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).meeting_time_date,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  color: Colors.black54)),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 50.0,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black
                        .withOpacity(widget.setValue != null ? 0.1 : 0.3)),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: InkWell(
              onTap: () {
                if (selectedDateTime != null) {
                  selectedTime =
                      CommonUtil.instance.convertTo_DateTime(selectedDateTime);
                }
                datePicker();
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    selectedDateTime ?? "DD/MM/YYYY",
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontWeight: selectedDateTime == null
                            ? FontWeight.w400
                            : FontWeight.w500,
                        color: selectedDateTime == null
                            ? Colors.black.withOpacity(0.4)
                            : Colors.black),
                  )),
                  SizedBox(
                      width: 30,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Visibility(
              visible: widget.isSubmitted && TextUtil.isEmpty(selectedDateTime),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                child: Text(
                  S.of(context).select_meeting_date_time,
                  style: TextStyle(
                      color: ColorConstants.redErrorColor, fontSize: 12.0),
                ),
              )),
        ],
      ),
    );
  }

  datePicker() {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: minDateTime,
        maxTime: maxDateTime,
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        selectedDateTime = CommonUtil.instance.convertTo_dd_MMM_yyyy_hhmm(date);
      });
      selectedTime = date;
      widget.onSelectDateTime(date);
    }, currentTime: selectedTime ?? currentTime, locale: LocaleType.en);
  }
}
