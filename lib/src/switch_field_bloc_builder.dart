import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/src/blocs/form/form_bloc.dart';

enum SwitchPosition { suffix, prefix }

class SwitchFieldBlocBuilder<T extends FormBloc> extends StatelessWidget {
  final String fieldName;
  final SwitchPosition switchPosition;
  final Widget body;

  const SwitchFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    required this.body,
    this.switchPosition = SwitchPosition.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(builder: (context, state) {
      return InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          prefixIcon: switchPosition == SwitchPosition.prefix
              ? _buildSwitch(context, state)
              : null,
          suffixIcon: switchPosition == SwitchPosition.suffix
              ? _buildSwitch(context, state)
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
    });
  }

  Switch _buildSwitch(BuildContext context, FormBlocState state) {
    return Switch(
      value: state.fields[this.fieldName]?.value ?? false,
      onChanged: (value) {
        context.read<T>().updateField(this.fieldName, value);
      },
    );
  }
}
