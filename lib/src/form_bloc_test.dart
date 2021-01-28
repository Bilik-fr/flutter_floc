import 'package:flutter_formbloc/flutter_formbloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc_test/bloc_test.dart';

@isTest
void formBlocTest<T extends FormBloc, Response>(
  String description, {
  @required T Function() build,
  FormStatus seed,
  Function(T formBloc) act,
  Duration wait,
  Function(FormStatus status, Response response, Map<String, FormField> fields)
      verify,
}) {
  blocTest<T, FormBlocState>(
    description,
    build: build,
    act: (bloc) {
      if (seed != null) {
        // ignore: invalid_use_of_visible_for_testing_member
        bloc.emit(bloc.state.copyWith(status: seed));
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
