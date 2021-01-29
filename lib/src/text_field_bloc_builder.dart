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
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget obscureTextFalseIcon;
  final Widget obscureTextTrueIcon;
  final TextStyle style;
  final SuffixAction suffixAction;

  /// Create a text field input
  ///
  /// This should be place after the FormBlocListener in the widget tree.
  /// Listen on bloc to change value dynamically and display eventual error key.
  TextFieldBlocBuilder({
    Key key,
    @required this.fieldName,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.obscureText = false,
    this.obscureTextFalseIcon = const Icon(Icons.visibility_off),
    this.obscureTextTrueIcon = const Icon(Icons.visibility),
    this.style,
    this.suffixAction,
  })  : assert(obscureTextFalseIcon != null),
        assert(obscureTextTrueIcon != null),
        super(key: key);

  @override
  _TextFieldBlocBuilderState createState() => _TextFieldBlocBuilderState<T>();
}

class _TextFieldBlocBuilderState<T extends FormBloc>
    extends State<TextFieldBlocBuilder> {
  bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[widget.fieldName] != current.fields[widget.fieldName],
      builder: (context, state) {
        return TextField(
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
      }
    }

    return decoration.copyWith(
      errorText: context.watch<T>().fieldError(widget.fieldName),
    );
  }
}
