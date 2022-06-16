import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:intl/intl.dart';

enum DateTimeFieldBaseType {
  date,
  time,
  dateRange,
}

class DateTimeFieldBase<T extends FormBloc> extends StatefulWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  final DateTimeFieldBaseType type;

  final String? confirmText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DatePickerEntryMode initialEntryMode;
  final String? cancelText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? errorInvalidRangeText;
  final String? format;
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
  DateTimeFieldBase({
    Key? key,
    required this.type,
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
    this.format = 'mm-dd-yyyy',
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.locale,
  }) : super(key: key);

  @override
  _DateTimeFieldBaseState createState() => _DateTimeFieldBaseState<T>();
}

class _DateTimeFieldBaseState<T extends FormBloc>
    extends State<DateTimeFieldBase> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[widget.fieldName] != current.fields[widget.fieldName],
      builder: (context, state) {
        if (state.fields[widget.fieldName] != null) {
          if (state.fields[widget.fieldName]!.value != null) {
            _controller.text =
                _formatter(state.fields[widget.fieldName]!.value);
          } else {
            _controller.clear();
          }
        }

        return TextField(
          onTap: () => _showPicker(context, state).then((value) {
            if (value != null) {
              context.read<T>().updateField(widget.fieldName, value);
            }
          }),
          controller: _controller,
          decoration: _buildDecoration(context),
          style: widget.style,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          autofocus: widget.autofocus,
          autocorrect: widget.autocorrect,
          expands: widget.expands,
          readOnly: true,
        );
      },
    );
  }

  String _formatter(dynamic value) {
    if (value == null) {
      return '';
    }
    switch (widget.type) {
      case DateTimeFieldBaseType.date:
        return DateFormat(widget.format).format(value);
      case DateTimeFieldBaseType.time:
        return DateFormat(widget.format)
            .format(DateTime(1, 1, 1, value?.hour ?? 0, value?.minute ?? 0));
      case DateTimeFieldBaseType.dateRange:
        return DateFormat('${widget.format}').format(value.start) +
            ' - ' +
            DateFormat('${widget.format}').format(value.end);
    }
  }

  Future<dynamic> _showPicker(BuildContext context, FormBlocState state) async {
    switch (widget.type) {
      case DateTimeFieldBaseType.date:
        return _showDatePicker(context, state);
      case DateTimeFieldBaseType.time:
        return _showTimePicker(context, state);
      case DateTimeFieldBaseType.dateRange:
        return _showDateRangePicker(context, state);
    }
  }

  InputDecoration _buildDecoration(BuildContext context) {
    InputDecoration decoration = widget.decoration;

    if (widget.clearable) {
      decoration = decoration.copyWith(
        suffixIcon: InkWell(
          borderRadius: BorderRadius.circular(25),
          child: widget.clearIcon,
          onTap: () {
            _controller.clear();
            context.read<T>().updateField(widget.fieldName, null);
          },
        ),
      );
    }
    return decoration.copyWith(
      errorText: context.read<T>().fieldError(widget.fieldName),
    );
  }

  Future<DateTimeRange?> _showDateRangePicker(
      BuildContext context, FormBlocState state) async {
    return await showDateRangePicker(
        context: context,
        builder: widget.builder,
        initialDateRange: state.fields[widget.fieldName]!.value != null
            ? state.fields[widget.fieldName]!.value
            : DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(Duration(days: 7))),
        locale: widget.locale,
        firstDate: widget.firstDate ?? DateTime(1900),
        lastDate: widget.lastDate ?? DateTime(2050),
        confirmText: widget.confirmText,
        initialEntryMode: widget.initialEntryMode,
        cancelText: widget.cancelText,
        errorFormatText: widget.errorFormatText,
        errorInvalidText: widget.errorInvalidText,
        errorInvalidRangeText: widget.errorInvalidRangeText,
        helpText: widget.helpText,
        fieldEndHintText: widget.fieldEndHintText,
        fieldEndLabelText: widget.fieldEndLabelText,
        fieldStartHintText: widget.fieldStartHintText,
        fieldStartLabelText: widget.fieldStartLabelText,
        saveText: widget.saveText);
  }

  Future<DateTime?> _showDatePicker(
      BuildContext context, FormBlocState state) async {
    return await showDatePicker(
      context: context,
      builder: widget.builder,
      initialDate: state.fields[widget.fieldName]!.value != null
          ? state.fields[widget.fieldName]!.value
          : DateTime.now(),
      locale: widget.locale,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2050),
      confirmText: widget.confirmText,
      initialEntryMode: widget.initialEntryMode,
      cancelText: widget.cancelText,
      errorFormatText: widget.errorFormatText,
      errorInvalidText: widget.errorInvalidText,
      helpText: widget.helpText,
    );
  }

  Future<TimeOfDay?> _showTimePicker(
      BuildContext context, FormBlocState state) async {
    return showTimePicker(
      context: context,
      builder: widget.builder,
      initialTime: state.fields[widget.fieldName]!.value != null
          ? state.fields[widget.fieldName]!.value
          : TimeOfDay.now(),
      confirmText: widget.confirmText,
      cancelText: widget.cancelText,
      errorInvalidText: widget.errorInvalidText,
      helpText: widget.helpText,
    );
  }
}
