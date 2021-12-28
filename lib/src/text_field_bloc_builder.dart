import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

enum SuffixAction {
  obscureText,
}

class TextFieldBlocBuilder<T extends FormBloc> extends StatefulWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;

  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? obscureTextFalseIcon;
  final Widget? obscureTextTrueIcon;
  final TextStyle? style;
  final SuffixAction? suffixAction;

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
    this.suffixAction,
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
        );
      },
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    InputDecoration decoration = widget.decoration;

    if (widget.suffixAction != null) {
      switch (widget.suffixAction) {
        case SuffixAction.obscureText:
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
      errorText: context.watch<T>().fieldError(widget.fieldName),
    );
  }
}
