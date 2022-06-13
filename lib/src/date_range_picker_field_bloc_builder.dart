import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

class DateRangePickerFormFieldBlocBuilder<T extends FormBloc>
    extends StatefulWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  final bool obscureText;
  final Widget? obscureTextFalseIcon;
  final Widget? obscureTextTrueIcon;
  final InputDecoration decoration;
  final TextStyle? style;
  final SuffixButton? suffixButton;
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
    this.keyboardType,
    this.obscureText = false,
    this.obscureTextFalseIcon = const Icon(Icons.visibility_off),
    this.obscureTextTrueIcon = const Icon(Icons.visibility),
    this.style,
    this.suffixButton,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
    this.autocorrect = true,
    this.enabled,
    this.expands = false,
    this.readOnly = false,
    this.enableSuggestions = true,
  }) : super(key: key);

  @override
  _DateRangePickerFormFieldBlocBuilderState createState() =>
      _DateRangePickerFormFieldBlocBuilderState<T>();
}

class _DateRangePickerFormFieldBlocBuilderState<T extends FormBloc>
    extends State<DateRangePickerFormFieldBlocBuilder> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = TextEditingController();
  }

  String _formatDateTimeRange(DateTimeRange? dateTimeRange) {
    if (dateTimeRange == null) {
      return '';
    }
    return '${dateTimeRange.start.day}/${dateTimeRange.start.month}/${dateTimeRange.start.year} - ${dateTimeRange.end.day}/${dateTimeRange.end.month}/${dateTimeRange.end.year}';
  }

  Future<DateTimeRange?> _showDateRangePicker(
      BuildContext context, FormBlocState state) async {
    print('${state.fields[widget.fieldName]}');
    return await showDateRangePicker(
        context: context,
        initialDateRange: state.fields[widget.fieldName]!.value != null
            ? state.fields[widget.fieldName]!.value
            : DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(Duration(days: 7))),
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
        confirmText: 'Confirm');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[widget.fieldName] != current.fields[widget.fieldName],
      builder: (context, state) {
        if (state.fields[widget.fieldName] != null &&
            _controller.text !=
                _formatDateTimeRange(state.fields[widget.fieldName]?.value)) {
          _controller.text =
              _formatDateTimeRange(state.fields[widget.fieldName]!.value);
        }

        return TextField(
          onTap: () => _showDateRangePicker(context, state).then((value) =>
              context.read<T>().updateField(widget.fieldName, value)),
          controller: _controller,
          decoration: _buildDecoration(context),
          obscureText: _obscureText,
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

    if (widget.suffixButton != null) {
      switch (widget.suffixButton) {
        case SuffixButton.obscureText:
          decoration = decoration.copyWith(
            suffixIcon: InkWell(
              borderRadius: BorderRadius.circular(25),
              child: _obscureText
                  ? widget.obscureTextTrueIcon
                  : widget.obscureTextFalseIcon,
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          );
          break;
        default:
          break;
      }
    }
    return decoration.copyWith(
      errorText: context.read<T>().fieldError(widget.fieldName),
    );
  }
}
