import 'package:flutter/material.dart';

abstract class DataSource {
  void dispose();
}

class MeetingPlannerDataProvider<T extends DataSource> extends StatefulWidget {
  MeetingPlannerDataProvider({
    Key key,
    @required this.child,
    @required this.dataSource,
  }) : super(key: key);

  final Widget child;
  final T dataSource;

  @override
  _DataProviderState<T> createState() => _DataProviderState<T>();

  static T of<T extends DataSource>(BuildContext context) {
    _DataProviderInherited<T> provider = context
        .getElementForInheritedWidgetOfExactType<_DataProviderInherited<T>>()
        .widget;
    return provider.dataSource;
  }
}

class _DataProviderState<T extends DataSource>
    extends State<MeetingPlannerDataProvider<T>> {
  @override
  void dispose() {
    widget.dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _DataProviderInherited<T>(
        child: widget.child,
        dataSource: widget.dataSource,
      ),
    );
  }
}

class _DataProviderInherited<T> extends InheritedWidget {
  _DataProviderInherited({
    Key key,
    @required Widget child,
    @required this.dataSource,
  }) : super(key: key, child: child);

  final T dataSource;

  @override
  bool updateShouldNotify(_DataProviderInherited oldWidget) => false;
}
