import 'package:flutter/material.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/utils/shared_preference_helper.dart';
import 'package:meeting_planner/widgets/common_widget.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

class TimeZoneScreen extends StatefulWidget {
  static const ROUTE_NAME = "/home/settings/timezone_screen";

  TimeZoneScreenArguments arguments;

  TimeZoneScreen(this.arguments);

  @override
  _TimeZoneScreenState createState() => _TimeZoneScreenState();
}

class _TimeZoneScreenState extends State<TimeZoneScreen> with CommonWidget {
  List<timezone.Location> list, filteredList = List();

  @override
  void initState() {
    list = timezone.timeZoneDatabase.locations.values.toList();
    filteredList.addAll(list);
    super.initState();
  }

  Future<bool> _willPopScope() {
    widget.arguments.onUpdate();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        appBar:
            getAppBar(context, S.of(context).timezone, onBackPressed: (from) {
          widget.arguments.onUpdate();
          Navigator.of(context).pop();
        }),
        body: SafeArea(
          child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _searchBar(),
                      SizedBox(height: 10.0),
                      Expanded(
                          child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              prefsHelper.setTimeZone(filteredList[index].name);
                              widget.arguments.onUpdate();
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                filteredList[index].name,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ))
                    ],
                  ))),
        ),
      ),
    );
  }

  _searchBar() {
    return TextFormField(
      maxLines: 1,
      decoration: InputDecoration(
        suffixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        hintText: 'Search',
        contentPadding: EdgeInsets.only(left: 15.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 1.5, style: BorderStyle.solid, color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      ),
      onChanged: (value) {
        setState(() {
          if (value.length == 0) {
            filteredList.clear();
            filteredList.addAll(list);
          } else {
            filteredList.clear();
            for (var item in list) {
              if (item.name.toLowerCase().contains(value.toLowerCase())) {
                filteredList.add(item);
              }
            }
          }
        });
      },
    );
  }
}

class TimeZoneScreenArguments {
  Function() onUpdate;
  TimeZoneScreenArguments(this.onUpdate);
}
