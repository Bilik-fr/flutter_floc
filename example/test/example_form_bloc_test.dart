import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc_example/blocs/example_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExampleFormBloc', () {
    formBlocTest<ExampleFormBloc, String>(
      'should contains [username, password, confirmPassword] field',
      build: () => ExampleFormBloc(),
      verify: (status, response, fields) {
        expect(fields.containsKey('username'), true);
        expect(fields.containsKey('password'), true);
        expect(fields.containsKey('confirmPassword'), true);
      },
    );

    formBlocTest<ExampleFormBloc, String>(
      'field [confirmPassword] should be subscribed to [password]',
      build: () => ExampleFormBloc(),
      verify: (status, response, fields) {
        expect(
          fields['confirmPassword']
              .getAllFieldSubscriptionNames()
              .contains('password'),
          true,
        );
      },
    );
    formBlocTest<ExampleFormBloc, String>(
      'should emit success on submit',
      build: () => ExampleFormBloc(),
      seed: FormStatus.valid,
      act: (formBloc) {
        formBloc.submit();
      },
      verify: (status, response, fields) {
        expect(status, FormStatus.success);
        expect(response, 'success response : ok');
      },
    );
  });
}
