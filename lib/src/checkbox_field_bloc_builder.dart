import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/src/blocs/form/form_bloc.dart';

enum CheckboxPosition { suffix, prefix }

class CheckboxFieldBlocBuilder<T extends FormBloc> extends StatelessWidget {
  final String fieldName;
  final CheckboxPosition checkboxPosition;
  final Widget body;

  const CheckboxFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    required this.body,
    this.checkboxPosition = CheckboxPosition.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[this.fieldName] != current.fields[this.fieldName],
      builder: (context, state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            prefixIcon: checkboxPosition == CheckboxPosition.prefix
                ? _buildCheckbox(context, state)
                : null,
            suffixIcon: checkboxPosition == CheckboxPosition.suffix
                ? _buildCheckbox(context, state)
                : null,
            errorText: context.read<T>().fieldError(fieldName),
          ),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            alignment: AlignmentDirectional.centerStart,
            child: body,
          ),
        );
      },
    );
  }

  Checkbox _buildCheckbox(BuildContext context, FormBlocState state) {
    return Checkbox(
      value: state.fields[this.fieldName]?.value ?? false,
      onChanged: (value) {
        context.read<T>().updateField(this.fieldName, value);
      },
    );
  }
}
