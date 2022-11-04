import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

class DropdownButtonFormFieldBlocBuilder<T extends FormBloc, Value>
    extends StatelessWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;
  final List<Value>? items;
  final Widget? hint;
  final Widget? disabledHint;
  final InputDecoration decoration;
  final DropdownMenuItem<Value> Function(BuildContext context, Value item)
      itemBuilder;
  final VoidCallback? onTap;
  final int elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? dropdownColor;
  final AutovalidateMode? autovalidateMode;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final BorderRadius? borderRadius;

  const DropdownButtonFormFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    required this.items,
    required this.itemBuilder,
    this.hint,
    this.disabledHint,
    this.decoration = const InputDecoration(),
    this.onTap,
    this.elevation = 8,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = true,
    this.isExpanded = false,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.autovalidateMode,
    this.menuMaxHeight,
    this.enableFeedback,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[this.fieldName] != current.fields[this.fieldName],
      builder: (context, state) {
        return DropdownButtonFormField<Value>(
          decoration: _buildDecoration(context),
          items: items?.map((e) => itemBuilder(context, e)).toList(),
          hint: hint,
          disabledHint: disabledHint,
          elevation: elevation,
          onChanged: (value) {
            context.read<T>().updateField(this.fieldName, value);
          },
          value: state.fields[this.fieldName]?.value,
          onTap: onTap,
          style: style,
          icon: icon,
          iconDisabledColor: iconDisabledColor,
          iconEnabledColor: iconEnabledColor,
          iconSize: iconSize,
          isDense: isDense,
          isExpanded: isExpanded,
          itemHeight: itemHeight,
          focusColor: focusColor,
          focusNode: focusNode,
          autofocus: autofocus,
          dropdownColor: dropdownColor,
          autovalidateMode: autovalidateMode,
          menuMaxHeight: menuMaxHeight,
        );
      },
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    return decoration.copyWith(
      errorText: context.read<T>().fieldError(fieldName),
    );
  }
}
