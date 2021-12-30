import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/src/blocs/form/form_bloc.dart';

class CheckboxFieldBlocBuilder<T extends FormBloc> extends StatelessWidget {
  final String fieldName;

  const CheckboxFieldBlocBuilder({Key? key, required this.fieldName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[this.fieldName] != current.fields[this.fieldName],
      builder: (context, state) {
        return Checkbox(
          value: state.fields[this.fieldName]?.value ?? false,
          onChanged: (value) {
            context.read<T>().updateField(this.fieldName, value);
          },
        );
      },
    );
  }
}
