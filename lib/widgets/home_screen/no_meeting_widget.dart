import 'package:flutter/material.dart';
import 'package:meeting_planner/datasource/home/home_datasource.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/utils/common_util.dart';

class NoMeetingWidget extends StatelessWidget {
  HomeDataSource homeDataSource;

  NoMeetingWidget(this.homeDataSource);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Icon(
                Icons.no_meeting_room,
                size: 48.0,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            StreamBuilder<DateTime>(
                stream: homeDataSource.selectedDateTimeStream,
                builder: (context, snapshot) {
                  String text = S.of(context).no_meetings_available;
                  if (snapshot.hasData) {
                    String date = CommonUtil.instance
                        .convertTo_dd_MMM_yyyy(snapshot.data);
                    text = text + " on $date";
                    if (!CommonUtil.instance.isPast(snapshot.data)) {
                      text = text + "\n" + S.of(context).add_meeting;
                    }
                  }
                  return Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  );
                })
          ],
        ),
      ),
    );
  }
}
