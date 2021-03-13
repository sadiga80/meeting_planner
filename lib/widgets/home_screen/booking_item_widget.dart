import 'package:flutter/material.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/model/booking.dart';
import 'package:meeting_planner/utils/common_util.dart';
import 'package:meeting_planner/widgets/custom_expansion_tile.dart';

class BookingItemWidget extends StatelessWidget {
  final BookingItem bookingItem;
  Function(BookingItem) onItemClick;

  BookingItemWidget(this.bookingItem, this.onItemClick);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        onItemClick(bookingItem);
      },
      child: CustomExpansionTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: Color(bookingItem.colorCode)),
          child: Center(
            child: Text(
              bookingItem.meetingRoom,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..strokeWidth = 1
                  ..color = Colors.white70,
              ),
            ),
          ),
        ),
        backgroundColor:
            bookingItem.isCancelled == 1 ? Colors.red.shade50 : Colors.white,
        title: Text(
          bookingItem.title,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 240,
              child: Text(bookingItem.description,
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
                  overflow: TextOverflow.ellipsis),
            ),
            Text(
              bookingItem.priority == 1
                  ? "HIGH"
                  : bookingItem.priority == 2
                      ? "MEDIUM"
                      : "LOW",
              style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: bookingItem.priority == 1
                      ? Colors.red
                      : bookingItem.priority == 2
                          ? Colors.amber
                          : Colors.green),
            ),
          ],
        ),
        children: [
          Row(
            children: [
              Text(
                S.of(context).meeting_time,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
              ),
              Text(
                CommonUtil.instance.convertTo_dd_MMM_yyyy_hhmm(CommonUtil
                    .instance
                    .convertTo_DateTime(bookingItem.dateTime)),
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    color: ColorConstants.primaryColor),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                S.of(context).meeting_duration_,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
              ),
              Text(
                "${bookingItem.meetingDuration} minutes",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    color: ColorConstants.primaryColor),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          if (bookingItem.isCancelled == 1)
            Row(
              children: [
                Text(
                  S.of(context).booking_status,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0),
                ),
                Text(
                  S.of(context).cancel_status,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                      color: Colors.red),
                ),
              ],
            )
        ],
      ),
    );
  }
}
