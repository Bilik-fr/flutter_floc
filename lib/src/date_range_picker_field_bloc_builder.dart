import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

class DateRangePickerFormFieldBlocBuilder<T extends FormBloc>
    extends StatefulWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  ///
  final String? confirmText;
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
  DateRangePickerFormFieldBlocBuilder({
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
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.locale,
  }) : super(key: key);

  @override
  _DateRangePickerFormFieldBlocBuilderState createState() =>
      _DateRangePickerFormFieldBlocBuilderState<T>();
}

class _DateRangePickerFormFieldBlocBuilderState<T extends FormBloc>
    extends State<DateRangePickerFormFieldBlocBuilder> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  String _defaultDateTimeRangeToStringFormatter(DateTimeRange? dateTimeRange) {
    if (dateTimeRange == null) {
      return '';
    }
    return '${dateTimeRange.start.year}-${dateTimeRange.start.month}-${dateTimeRange.start.day} - ${dateTimeRange.end.year}-${dateTimeRange.end.month}-${dateTimeRange.end.day}';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[widget.fieldName] != current.fields[widget.fieldName],
      builder: (context, state) {
        if (state.fields[widget.fieldName] != null) {
          if (state.fields[widget.fieldName]!.value != null) {
            _controller.text = widget.dateTimeRangeToStringFormatter != null
                ? widget.dateTimeRangeToStringFormatter!(
                    state.fields[widget.fieldName]!.value)
                : _defaultDateTimeRangeToStringFormatter(
                    state.fields[widget.fieldName]!.value);
          } else {
            _controller.clear();
          }
        }

        return TextField(
          onTap: () => _showDateRangePicker(context, state).then((value) {
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
}
