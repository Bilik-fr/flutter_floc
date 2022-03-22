import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc_example/validator.dart';

class ExampleFormBloc extends FormBloc<String> {
  ExampleFormBloc() {
    addFields([password, username, confirmPassword, accept, accept2]);
  }

  static final username = FormField<String>(
    name: 'username',
    initialValue: '',
    validators: [
      FieldValidator(Validator.required),
    ],
  );

  static final password = FormField<String>(
    name: 'password',
    initialValue: '',
    validators: [
      FieldValidator(Validator.required),
      FieldValidator(Validator.min6Chars),
    ],
  );

  static final confirmPassword = FormField<String>(
    name: 'confirmPassword',
    initialValue: '',
    validators: [
      FieldValidator(Validator.required),
      FieldValidator(
        Validator.confirmPassword,
        fieldSubscriptions: [password],
      ),
    ],
  );

  static final accept = FormField<bool>(
    name: 'acceptSwitch',
    initialValue: false,
    validators: [
      FieldValidator(Validator.required),
    ],
  );

  static final accept2 = FormField<bool>(
    name: 'acceptCheckbox',
    initialValue: false,
    validators: [
      FieldValidator(Validator.required),
    ],
  );

  @override
  void onSubmit(fields) async {
    print('username: ${fields['username']}');
    print('password: ${fields['password']}');
    print('confirmPassword: ${fields['confirmPassword']}');
    print('acceptSwitch: ${fields['acceptSwitch']}');
    print('acceptCheckbox: ${fields['acceptCheckbox']}');
    emitSuccess('success response : ok');
  }
}
