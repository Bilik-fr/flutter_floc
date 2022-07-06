import 'package:flutter/material.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc/src/date_time_field_base.dart';

class DateRangePickerFieldBlocBuilder<T extends FormBloc>
    extends StatelessWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  ///
  final String? format;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DatePickerEntryMode? initialEntryMode;
  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final Icon? clearIcon;

  final InputDecoration decoration;
  final TextStyle? style;
  final bool clearable;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Create a text field input
  ///
  /// This should be place after the FormBlocListener in the widget tree.
  /// Listen on bloc to change value dynamically and display eventual error key.
  DateRangePickerFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    this.decoration = const InputDecoration(),
    this.builder,
    this.clearIcon = const Icon(Icons.clear),
    this.style,
    this.clearable = false,
    this.autofocus = false,
    this.format,
    this.firstDate,
    this.lastDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeFieldBase<T>(
      fieldName: this.fieldName,
      type: DateTimeFieldBaseType.dateRange,
      autofocus: this.autofocus,
      builder: this.builder,
      format: this.format,
      clearIcon: this.clearIcon,
      clearable: this.clearable,
      decoration: this.decoration,
      initialDateRangePickerEntryMode: this.initialEntryMode,
      locale: this.locale,
    );
  }
}
