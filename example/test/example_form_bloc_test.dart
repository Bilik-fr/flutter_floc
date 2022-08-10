import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc_example/blocs/example_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExampleFormBloc', () {
    formBlocTest<ExampleFormBloc, String>(
      'should contains [dropdown, phone, username, password, confirmPassword, time, date, dateRange] field',
      build: () => ExampleFormBloc(),
      verify: (status, response, fields) {
        expect(fields.containsKey('username'), true);
        expect(fields.containsKey('password'), true);
        expect(fields.containsKey('confirmPassword'), true);
        expect(fields.containsKey('dropdown'), true);
        expect(fields.containsKey('phone'), true);
        expect(fields.containsKey('time'), true);
        expect(fields.containsKey('date'), true);
        expect(fields.containsKey('dateRange'), true);
      },
    );

    formBlocTest<ExampleFormBloc, String>(
      'field [confirmPassword] should be subscribed to [password]',
      build: () => ExampleFormBloc(),
      verify: (status, response, fields) {
        expect(
          fields['confirmPassword']
              ?.getAllFieldSubscriptionNames()
              .contains('password'),
          true,
        );
      },
    );

    formBlocTest<ExampleFormBloc, String>(
      'should emit success on submit',
      build: () => ExampleFormBloc(),
      seed: {
        'dropdown': 1,
        'username': 'user',
        'password': 'magicpassword',
        'confirmPassword': 'magicpassword',
        'acceptSwitch': true,
        'acceptCheckbox': true,
        'date': DateTime.now(),
        'time': TimeOfDay.now(),
        'dateRange': DateTimeRange(start: DateTime.now(), end: DateTime.now()),
        'phone': OurPhoneNumber(isoCode: IsoCode.FR, nsn: '634248735'),
      },
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
