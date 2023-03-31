import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneFormFieldBlocBuilder<T extends FormBloc> extends StatelessWidget {
  /// Fieldname to map with a field of the parent FormBloc in the widget tree
  final String fieldName;
  final String? hint;
  final IsoCode? initialCountryCode;
  final InputDecoration decoration;

  const PhoneFormFieldBlocBuilder({
    Key? key,
    required this.fieldName,
    this.decoration = const InputDecoration(),
    this.hint,
    this.initialCountryCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      buildWhen: (previous, current) =>
          previous.fields[this.fieldName] != current.fields[this.fieldName],
      builder: (context, state) {
        return PhoneFormField(
          decoration: _buildDecoration(context),
          validator: PhoneValidator.none,
          countrySelectorNavigator: CountrySelectorNavigator.modalBottomSheet(),
          defaultCountry:
              initialCountryCode != null ? initialCountryCode! : IsoCode.FR,
          onChanged: (phone) {
            print(phone!.international);
            context.read<T>().updateField(this.fieldName,
                OurPhoneNumber(isoCode: phone!.isoCode, nsn: phone.nsn));
          },
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
