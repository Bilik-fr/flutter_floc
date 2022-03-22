import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

enum SuffixButton {
  obscureText,
}

class TextFieldBlocBuilder<T extends FormBloc> extends StatefulWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  final bool obscureText;
  final Widget? obscureTextFalseIcon;
  final Widget? obscureTextTrueIcon;
  final InputDecoration decoration;
  final TextStyle? style;
  final SuffixButton? suffixButton;
  final int? maxLength;
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
  TextFieldBlocBuilder({
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
    this.maxLength,
    this.enabled,
    this.expands = false,
    this.readOnly = false,
    this.enableSuggestions = true,
  }) : super(key: key);

  @override
  _TextFieldBlocBuilderState createState() => _TextFieldBlocBuilderState<T>();
}

class _TextFieldBlocBuilderState<T extends FormBloc>
    extends State<TextFieldBlocBuilder> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[widget.fieldName] != current.fields[widget.fieldName],
      builder: (context, state) {
        if (state.fields[widget.fieldName] != null &&
            _controller.text != state.fields[widget.fieldName]?.value) {
          _controller.text = state.fields[widget.fieldName]?.value;
        }

        return TextField(
          controller: _controller,
          decoration: _buildDecoration(context),
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          onChanged: (value) {
            context.read<T>().updateField(widget.fieldName, value);
          },
          style: widget.style,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          autofocus: widget.autofocus,
          autocorrect: widget.autocorrect,
          maxLength: widget.maxLength,
          enabled: widget.enabled,
          expands: widget.expands,
          readOnly: widget.readOnly,
          enableSuggestions: widget.enableSuggestions,
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
