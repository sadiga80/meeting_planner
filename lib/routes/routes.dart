import 'package:flutter/material.dart';
import 'package:meeting_planner/routes/custom_page_route.dart';
import 'package:meeting_planner/screen/meeting_booking.dart';
import 'package:meeting_planner/screen/home.dart';
import 'package:meeting_planner/screen/office_hours.dart';
import 'package:meeting_planner/screen/settings.dart';
import 'package:meeting_planner/screen/timezone_list.dart';

class Routes {
  static onGenerateRoute(RouteSettings routeSettings) {
    print('ROUTE NAME: ' + routeSettings.name);
    switch (routeSettings.name) {
      case HomeScreen.ROUTE_NAME:
        return _navigate(HomeScreen(), routeSettings);
      case MeetingBookingScreen.ROUTE_NAME:
        return _navigate(
            MeetingBookingScreen(routeSettings.arguments), routeSettings);
      case SettingsScreen.ROUTE_NAME:
        return _navigate(
            SettingsScreen(routeSettings.arguments), routeSettings);
      case OfficeHoursScreen.ROUTE_NAME:
        return _navigate(
            OfficeHoursScreen(routeSettings.arguments), routeSettings);
      case TimeZoneScreen.ROUTE_NAME:
        return _navigate(
            TimeZoneScreen(routeSettings.arguments), routeSettings);
    }
    return null;
  }
}

_navigate(Widget child, RouteSettings settings) {
  return CustomPageRoute(
      settings: settings,
      builder: (context) {
        return child;
      });
}
