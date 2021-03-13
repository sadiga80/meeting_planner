import 'package:flutter/material.dart';
import 'package:meeting_planner/color.dart';
import 'package:meeting_planner/generated/l10n.dart';
import 'package:meeting_planner/utils/book_meeting_validator.dart';

class DescriptionWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController textEditingController;
  final bool isSubmitted;
  final bool isEnabled;

  DescriptionWidget(this.formKey, this.textEditingController, this.isSubmitted,
      this.isEnabled)
      : assert(formKey != null || textEditingController != null);

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
      controller: widget.textEditingController,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      maxLines: 2,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding:
            new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(),
        labelText: S.of(context).description,
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
        hintText: S.of(context).enter_description,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorConstants.primaryColor, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
        ),
      ),
      onChanged: (text) {
        if (widget.isSubmitted ?? true) {
          widget.formKey.currentState.validate();
        }
      },
      validator: (value) =>
          BookMeetingValidator.checkDescriptionError(context, value),
    );
  }
}
