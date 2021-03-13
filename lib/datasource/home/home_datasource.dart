import 'package:meeting_planner/datasource/home/book_meeting/booking_data_provider.dart';
import 'package:meeting_planner/model/booking.dart';
import 'package:meeting_planner/utils/common_util.dart';
import 'package:rxdart/rxdart.dart';

import '../datasource.dart';

class HomeDataSource extends DataSource {
  BehaviorSubject<List<BookingItem>> _bookingStreamController =
      BehaviorSubject();
  Stream<List<BookingItem>> get bookingsStream =>
      _bookingStreamController.stream;
  Function(List<BookingItem>) get changesBookings =>
      _bookingStreamController.sink.add;
  List<BookingItem> get bookingsList => _bookingStreamController.value;

  BehaviorSubject<DateTime> _selectedDateTimeController = BehaviorSubject();
  Stream<DateTime> get selectedDateTimeStream =>
      _selectedDateTimeController.stream;
  Function(DateTime) get changesSelectedDateTime =>
      _selectedDateTimeController.sink.add;
  DateTime get selectedDateTime => _selectedDateTimeController.value;

  Future<BookingItem> insertData(BookingItem bookingItem) async {
    var dbHelper = DBHelper();
    return await dbHelper.insert(bookingItem).then((item) {
      return item;
    });
  }

  Future<int> removeData(int id) async {
    var dbHelper = DBHelper();
    return await dbHelper.delete(id).then((item) {
      return id;
    });
  }

  Future<BookingItem> updateData(BookingItem bookingItem) async {
    var dbHelper = DBHelper();
    return await dbHelper.updateData(bookingItem).then((item) {
      return bookingItem;
    });
  }

  Future<List<BookingItem>> getAllBookings({DateTime dateTime}) async {
    var dbHelper = DBHelper();
    return await dbHelper.getAllBookings().then((items) {
      if (dateTime != null) {
        List<BookingItem> bookingItems = List();
        items.forEach((element) {
          DateTime itemDateTime =
              CommonUtil.instance.convertTo_DateTime(element.dateTime);
          if (itemDateTime != null) {
            String itemDateTimeString =
                "${itemDateTime.year}-${itemDateTime.month}-${itemDateTime.day}";
            String selectedDateTimeString =
                "${dateTime.year}-${dateTime.month}-${dateTime.day}";
            if (itemDateTimeString.compareTo(selectedDateTimeString) == 0) {
              bookingItems.add(element);
            }
          }
          return bookingItems;
        });
        return bookingItems;
      }
      return items;
    });
  }

  @override
  void dispose() {
    _bookingStreamController.close();
    _selectedDateTimeController.close();
  }
}
