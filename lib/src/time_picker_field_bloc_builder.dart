import 'package:flutter/material.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc/src/date_time_field_base.dart';

class TimePickerFieldBlocBuilder<T extends FormBloc> extends StatelessWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  ///
  final String? confirmText;
  final String? format;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DatePickerEntryMode initialEntryMode;
  final String? cancelText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? errorInvalidRangeText;
  final String? helpText;
  final String? fieldEndHintText;
  final String? fieldEndLabelText;
  final String? fieldStartHintText;
  final String? fieldStartLabelText;
  final String? saveText;
  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final Icon? clearIcon;
  final String Function(DateTimeRange)? dateTimeRangeToStringFormatter;

  final InputDecoration decoration;
  final TextStyle? style;
  final bool clearable;
  final bool? enabled;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// {@macro flutter.services.textInput.enableSuggestions}
  final bool enableSuggestions;

  /// Create a text field input
  ///
  /// This should be place after the FormBlocListener in the widget tree.
  /// Listen on bloc to change value dynamically and display eventual error key.
  TimePickerFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    this.decoration = const InputDecoration(),
    this.builder,
    this.keyboardType,
    this.dateTimeRangeToStringFormatter,
    this.clearIcon = const Icon(Icons.clear),
    this.style,
    this.clearable = false,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
    this.autocorrect = true,
    this.enabled,
    this.expands = false,
    this.readOnly = false,
    this.enableSuggestions = true,
    this.firstDate,
    this.lastDate,
    this.confirmText,
    this.cancelText,
    this.errorFormatText,
    this.errorInvalidText,
    this.errorInvalidRangeText,
    this.helpText,
    this.fieldEndHintText,
    this.fieldEndLabelText,
    this.fieldStartHintText,
    this.fieldStartLabelText,
    this.saveText,
    this.format,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeFieldBase<T>(
      type: DateTimeFieldBaseType.time,
      fieldName: this.fieldName,
      autocorrect: this.autocorrect,
      autofocus: this.autofocus,
      clearable: this.clearable,
      clearIcon: this.clearIcon,
      decoration: this.decoration,
      enableSuggestions: this.enableSuggestions,
      expands: this.expands,
      firstDate: this.firstDate,
      initialEntryMode: this.initialEntryMode,
      lastDate: this.lastDate,
      locale: this.locale,
      maxLines: this.maxLines,
      minLines: this.minLines,
      readOnly: this.readOnly,
      style: this.style,
      keyboardType: this.keyboardType,
      dateTimeRangeToStringFormatter: this.dateTimeRangeToStringFormatter,
      builder: this.builder,
      confirmText: this.confirmText,
      cancelText: this.cancelText,
      errorFormatText: this.errorFormatText,
      errorInvalidText: this.errorInvalidText,
      errorInvalidRangeText: this.errorInvalidRangeText,
      helpText: this.helpText,
      format: this.format,
      fieldEndHintText: this.fieldEndHintText,
      fieldEndLabelText: this.fieldEndLabelText,
      fieldStartHintText: this.fieldStartHintText,
      fieldStartLabelText: this.fieldStartLabelText,
      saveText: this.saveText,
    );
  }
}
