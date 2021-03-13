import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meeting_planner/datasource/home/home_datasource.dart';
import 'package:meeting_planner/model/booking.dart';
import 'package:meeting_planner/model/room.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';
import 'package:meeting_planner/widgets/common_widget.dart';
import 'package:meeting_planner/widgets/home_screen/no_meeting_widget.dart';

import 'booking_item_widget.dart';

class MeetingsListWidget extends StatefulWidget {
  HomeDataSource homeDataSource;
  Function(BookingItem) onItemClick;

  MeetingsListWidget(this.homeDataSource, this.onItemClick);

  @override
  _MeetingsListWidgetState createState() => _MeetingsListWidgetState();
}

class _MeetingsListWidgetState extends State<MeetingsListWidget>
    with CommonWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<BookingItem>>(
          initialData: widget.homeDataSource.bookingsList,
          stream: widget.homeDataSource.bookingsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BookingItem> bookings = snapshot.data;
              if (bookings.length != 0) {
                List<RoomItem> rooms = MeetingRooms.fromJson(
                    json.decode(prefsHelper.getMeetigRoomDetails()))
                    .meetingRooms;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      RoomItem item = rooms.firstWhere((element) {
                        return element.title
                            .compareTo(bookings[index].meetingRoom) ==
                            0;
                      });
                      bookings[index].colorCode = item.colorCode;
                      return _buildItem(bookings[index]);
                    });
              } else {
                return NoMeetingWidget(widget.homeDataSource);
              }
            } else {
              return getLoaderList(8);
            }
          }),
    );
  }

  Widget _buildItem(BookingItem booking) {
    return BookingItemWidget(booking, widget.onItemClick);
  }
}
