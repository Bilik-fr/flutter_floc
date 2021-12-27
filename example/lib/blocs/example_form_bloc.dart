import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc_example/validator.dart';

class ExampleFormBloc extends FormBloc<String> {
  ExampleFormBloc() {
    addFields([password, username, confirmPassword]);
  }

  static final username = FormField<String>(
    name: 'username',
    defaultValue: '',
    validators: [
      FieldValidator(Validator.required),
    ],
  );

  static final password = FormField<String>(
    name: 'password',
    defaultValue: '',
    validators: [
      FieldValidator(Validator.required),
      FieldValidator(Validator.min6Chars),
    ],
  );

  static final confirmPassword = FormField<String>(
    name: 'confirmPassword',
    defaultValue: '',
    validators: [
      FieldValidator(Validator.required),
      FieldValidator(
        Validator.confirmPassword,
        fieldSubscriptions: [password],
      ),
    ],
  );

  @override
  void onSubmit(fields) async {
    print(fields['username']);
    print(fields['password']);
    print(fields['confirmPassword']);
    emitSuccess('success response : ok');
  }
}
