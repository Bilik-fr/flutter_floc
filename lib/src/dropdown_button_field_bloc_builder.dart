import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

class DropdownButtonFormFieldBlocBuilder<T extends FormBloc>
    extends StatelessWidget {
  final String fieldName;
  final List<Object?> items;
  final Widget? hint;
  final InputDecoration? decoration;
  final List<DropdownMenuItem<Object>> Function(List<Object?>) itemsBuilder;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTap;
  final int elevation = 8;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize = 24.0;
  final bool isDense = true;
  final bool isExpanded = false;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus = false;
  final Color? dropdownColor;
  final AutovalidateMode? autovalidateMode;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final BorderRadius? borderRadius;

  const DropdownButtonFormFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    required this.items,
    this.hint,
    this.decoration,
    required this.itemsBuilder,
    this.alignment,
    this.onTap,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
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
        print(items);
        return DropdownButtonFormField(
          decoration: _buildDecoration(context, decoration),
          items: itemsBuilder(items),
          hint: hint,
          onChanged: (value) =>
              context.read<T>().updateField(this.fieldName, value),
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
          enableFeedback: enableFeedback,
          borderRadius: borderRadius,
        );
      },
    );
  }

  InputDecoration _buildDecoration(
      BuildContext context, InputDecoration? decoration) {
    if (decoration != null)
      return decoration.copyWith(
        errorText: context.read<T>().fieldError(fieldName),
      );
    else {
      return InputDecoration(
        errorText: context.read<T>().fieldError(fieldName),
      );
    }
  }
}
