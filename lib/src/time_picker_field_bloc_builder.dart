import 'package:flutter/material.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc/src/date_time_field_base.dart';

class TimePickerFieldBlocBuilder<T extends FormBloc> extends StatelessWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  ///
  final String? format;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final Widget Function(BuildContext, Widget?)? builder;
  final Icon? clearIcon;

  final InputDecoration decoration;
  final TextStyle? style;
  final bool clearable;
  final TimePickerEntryMode initialEntryMode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Create a text field input
  ///
  /// This should be place after the FormBlocListener in the widget tree.
  /// Listen on bloc to change value dynamically and display eventual error key.
  TimePickerFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    this.decoration = const InputDecoration(),
    this.builder,
    this.clearIcon = const Icon(Icons.clear),
    this.style,
    this.clearable = false,
    this.autofocus = false,
    this.firstDate,
    this.lastDate,
    this.format,
    this.initialEntryMode = TimePickerEntryMode.input,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeFieldBase<T>(
      type: DateTimeFieldBaseType.time,
      fieldName: this.fieldName,
      autofocus: this.autofocus,
      clearable: this.clearable,
      clearIcon: this.clearIcon,
      decoration: this.decoration,
      style: this.style,
      builder: this.builder,
      format: this.format,
      initialTimePickerEntryMode: this.initialEntryMode,
    );
  }
}
