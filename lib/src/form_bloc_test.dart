import 'package:flutter_floc/flutter_floc.dart';
import 'package:meta/meta.dart';
import 'package:bloc_test/bloc_test.dart';

@isTest

/// Utility function to test FormBlocs instance.
///
/// ```dart
///formBlocTest<ExampleFormBloc, String>(
///  'should contains [username, password, confirmPassword] field',
///  build: () => ExampleFormBloc(),
///  verify: (status, response, fields) {
///  expect(fields.containsKey('username'), true);
///  expect(fields.containsKey('password'), true);
///  expect(fields.containsKey('confirmPassword'), true);
///  },
/// );
/// ```
void formBlocTest<T extends FormBloc, Response>(
  String description, {
  required T Function() build,
  Map<String, dynamic>? seed,
  Function(T formBloc)? act,
  Duration? wait,
  Function(FormStatus status, Response response, Map<String, FormField> fields)?
      verify,
}) {
  final formBloc = build();
  blocTest<T, FormBlocState>(
    description,
    build: () => formBloc,
    act: (bloc) {
      if (seed != null && seed.length > 0) {
        final stateSnapshot = formBloc.state.copyWith();

        stateSnapshot.fields.forEach((name, field) {
          if (seed[name] != null) {
            field.setValue(seed[name]);
          }
        });

        bloc.emit(stateSnapshot);
      }
      act?.call(bloc);
    },
    wait: wait,
    verify: (bloc) {
      verify?.call(
        bloc.state.status,
        bloc.state.response,
        bloc.state.fields,
      );
    },
  );
}
