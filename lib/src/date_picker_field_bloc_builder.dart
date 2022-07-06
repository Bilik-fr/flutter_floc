import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc/src/date_time_field_base.dart';

class DatePickerFieldBlocBuilder<T extends FormBloc> extends StatelessWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;
  final InputDecoration decoration;
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;
  final String? format;
  final bool clearable;
  final Icon? clearIcon;
  final Widget Function(BuildContext, Widget?)? builder;

  ///
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Locale? locale;
  final DatePickerMode initialDatePickerMode;

  /// Create a text field input
  ///
  /// This should be place after the FormBlocListener in the widget tree.
  /// Listen on bloc to change value dynamically and display eventual error key.
  DatePickerFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    this.decoration = const InputDecoration(),
    this.builder,
    this.clearIcon = const Icon(Icons.clear),
    this.style,
    this.clearable = false,
    this.firstDate,
    this.format,
    this.locale,
    this.autofocus = false,
    this.lastDate,
    this.initialDatePickerMode = DatePickerMode.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeFieldBase<T>(
      type: DateTimeFieldBaseType.date,
      fieldName: this.fieldName,
      autofocus: this.autofocus,
      clearable: this.clearable,
      clearIcon: this.clearIcon,
      decoration: this.decoration,
      firstDate: this.firstDate,
      lastDate: this.lastDate,
      initialDatePickerMode: this.initialDatePickerMode,
      locale: this.locale,
      style: this.style,
      builder: this.builder,
      format: this.format,
    );
  }
}
