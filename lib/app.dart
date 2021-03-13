import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/routes/routes.dart';
import 'package:meeting_planner/screen/home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();

  static const locale = [Locale("en", "")];

  static void setLocale(BuildContext context, Locale newLocale) async {
    _AppState state = context.findAncestorStateOfType();
    state.setState(() {
      state.locale = newLocale;
    });
  }
}

class _AppState extends State<App> {
  var locale = App.locale[0];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: ColorConstants.primaryColor,
          primaryColorDark: ColorConstants.primaryDarkColor,
          accentColor: ColorConstants.primaryLightColor,
          fontFamily: 'Poppins'),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: locale,
      home: HomeScreen(),
      onGenerateRoute: (RouteSettings settings) {
        return Routes.onGenerateRoute(settings);
      },
    );
  }
}
