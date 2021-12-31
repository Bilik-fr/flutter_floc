import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class FormFieldMock<T> extends Mock implements FormField<T> {
  void setup({required String name}) {
    // Reset mock
    reset(this);

    // Set default mock behavior
    when(() => this.name).thenReturn(name);
    when(() => this.copyWith()).thenReturn(this);
    when(() => this.validators).thenReturn([]);
    when(() => this.getAllFieldSubscriptionNames()).thenReturn([]);
    when(() => this.isTouched).thenReturn(true);
  }
}

class FieldValidatorMock<T> extends Mock implements FieldValidator<T> {}

class TestFormBloc extends FormBloc<String> {
  @override
  void onSubmit(Map<String, dynamic> fields) {}
}

void main() {
  FieldValidatorMock fieldValidatorMock = FieldValidatorMock();
  FormFieldMock formFieldMock = FormFieldMock();
  FormFieldMock formFieldMock2 = FormFieldMock();

  setUp(() {
    formFieldMock.setup(name: 'field');
    formFieldMock2.setup(name: 'field2');
  });

  group('FormBloc', () {
    test('initial state should be FormBlocState<String>', () {
      final testFormBloc = TestFormBloc();
      expect(testFormBloc.state, FormBlocState<String>());
      testFormBloc.close();
    });

    group('Submit', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should submit when status is [valid]',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(status: FormStatus.valid),
        act: (bloc) {
          bloc.submit();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.loading, fields: {}),
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should submit when status is [loading]',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(status: FormStatus.loading),
        act: (bloc) {
          bloc.submit();
        },
        expect: () => <FormBlocState<String>>[],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should submit when status is [success]',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(status: FormStatus.success),
        act: (bloc) {
          bloc.submit();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.loading, fields: {}),
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should submit when status is [failure]',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(status: FormStatus.failure),
        act: (bloc) {
          bloc.submit();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.loading, fields: {}),
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should validate and submit when status is [invalid] and validation succeed',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          status: FormStatus.invalid,
          fields: {'field': formFieldMock},
        ),
        act: (bloc) {
          bloc.submit();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
            status: FormStatus.valid,
            fields: {'field': formFieldMock},
          ),
          FormBlocState<String>(
            status: FormStatus.loading,
            fields: {'field': formFieldMock},
          ),
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should only validate when status is [invalid] and validation fails',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          status: FormStatus.invalid,
          fields: {'field': formFieldMock},
        ),
        act: (bloc) {
          when(() => formFieldMock.error).thenReturn('error');
          bloc.submit();
        },
        expect: () => <FormBlocState<String>>[],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should only validate when status is [pure] and validation fails',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          status: FormStatus.pure,
          fields: {'field': formFieldMock},
        ),
        act: (bloc) {
          when(() => formFieldMock.error).thenReturn('error');
          bloc.submit();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
            status: FormStatus.invalid,
            fields: {'field': formFieldMock},
          ),
        ],
      );
    });

    group('Validate', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should run all fields validation',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          bloc.validate();
        },
        verify: (bloc) {
          verify(() => formFieldMock.validate({})).called(1);
          verify(() => formFieldMock2.validate({})).called(1);
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should not run validation twice on each field that contains a validator suscribed to an another field',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          when(() => formFieldMock2.getAllFieldSubscriptionNames()).thenReturn(
            ['field'],
          );
          when(() => formFieldMock2.validators)
              .thenReturn([fieldValidatorMock]);
          when(() => fieldValidatorMock.getFieldSubscriptionNames())
              .thenReturn(['field']);

          bloc.validate();
        },
        verify: (bloc) {
          verify(() => formFieldMock.validate({})).called(1);
          verify(() => formFieldMock2.validate({'field': formFieldMock}))
              .called(1);
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [valid] when every fields have no error and touched',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
            fields: {'field': formFieldMock, 'field2': formFieldMock2}),
        act: (bloc) {
          bloc.validate();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
            status: FormStatus.valid,
            fields: {'field': formFieldMock, 'field2': formFieldMock2},
          )
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [invalid] when any field have an error',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
            fields: {'field': formFieldMock, 'field2': formFieldMock2}),
        act: (bloc) {
          when(() => formFieldMock2.error).thenReturn('error');
          bloc.validate();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
            status: FormStatus.invalid,
            fields: {'field': formFieldMock, 'field2': formFieldMock2},
          )
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [invalid] when any field is untouched',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
            fields: {'field': formFieldMock, 'field2': formFieldMock2}),
        act: (bloc) {
          when(() => formFieldMock2.isTouched).thenReturn(false);
          bloc.validate();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
            status: FormStatus.invalid,
            fields: {'field': formFieldMock, 'field2': formFieldMock2},
          )
        ],
      );
    });

    group('AddFields', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should add fields',
        build: () => TestFormBloc(),
        act: (bloc) {
          bloc.addFields([formFieldMock, formFieldMock2]);
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
              fields: {'field': formFieldMock, 'field2': formFieldMock2})
        ],
      );
    });

    group('UpdateField', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should throws an error when field is not found',
        build: () => TestFormBloc(),
        act: (bloc) {
          bloc.updateField('unknown', 'value');
        },
        errors: () => [
          isA<Exception>(),
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should set field value',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(fields: {'field': formFieldMock}),
        act: (bloc) {
          bloc.updateField('field', 'value');
        },
        verify: (bloc) {
          verify(() => formFieldMock.setValue('value')).called(1);
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should run validation on updated field (only this one)',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          bloc.updateField('field', 'value');
        },
        verify: (bloc) {
          verify(() => formFieldMock.validate({})).called(1);
          verifyNever(() => formFieldMock2.validate({}));
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should run validation on fields subscribed to updated field',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          when(() => formFieldMock2.getAllFieldSubscriptionNames())
              .thenReturn(['field']);
          when(() => formFieldMock2.validators)
              .thenReturn([fieldValidatorMock]);
          when(() => fieldValidatorMock.getFieldSubscriptionNames())
              .thenReturn(['field']);

          bloc.updateField('field', 'value');
        },
        verify: (bloc) {
          verify(() => formFieldMock.validate({})).called(1);
          verify(() => formFieldMock2.validate({'field': formFieldMock}))
              .called(1);
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should not run validation on fields which updated field are subscribed',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          when(() => formFieldMock.getAllFieldSubscriptionNames())
              .thenReturn(['field2']);
          when(() => formFieldMock.validators).thenReturn([fieldValidatorMock]);
          when(() => fieldValidatorMock.getFieldSubscriptionNames())
              .thenReturn(['field2']);
          bloc.updateField(('field'), 'value');
        },
        verify: (bloc) {
          verify(() => formFieldMock.validate({'field2': formFieldMock2}))
              .called(1);
          verifyNever(() => formFieldMock2.validate(any()));
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [invalid] when updated field validation fails',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          when(() => formFieldMock.error).thenReturn('error');
          bloc.updateField('field', 'value');
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
            status: FormStatus.invalid,
            fields: {'field': formFieldMock, 'field2': formFieldMock2},
          ),
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [valid] when field updated validation succeed (only when others fields are valid)',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          bloc.updateField('field', 'value');
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(
            status: FormStatus.valid,
            fields: {'field': formFieldMock, 'field2': formFieldMock2},
          ),
        ],
      );
    });

    group('EmitSuccess', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [success]',
        build: () => TestFormBloc(),
        act: (bloc) {
          bloc.emitSuccess();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.success)
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should emit [response] if specified',
        build: () => TestFormBloc(),
        act: (bloc) {
          bloc.emitSuccess('success');
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.success, response: 'success')
        ],
      );
    });

    group('EmitFailure', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [failure]',
        build: () => TestFormBloc(),
        act: (bloc) {
          bloc.emitFailure();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.failure)
        ],
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should emit [response] if specified',
        build: () => TestFormBloc(),
        act: (bloc) {
          bloc.emitFailure('failure');
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.failure, response: 'failure')
        ],
      );
    });

    group('FieldError', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should return the field error',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(fields: {'field': formFieldMock}),
        verify: (bloc) {
          when(() => formFieldMock.error).thenReturn('error');
          expect(bloc.fieldError('field'), 'error');
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should return [null] when field is not found',
        build: () => TestFormBloc(),
        verify: (bloc) {
          expect(bloc.fieldError('field'), null);
        },
      );
    });

    group('FieldErrors', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should return all field errors',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
            fields: {'field': formFieldMock, 'field2': formFieldMock2}),
        verify: (bloc) {
          when(() => formFieldMock.error).thenReturn(null);
          when(() => formFieldMock2.error).thenReturn('error');
          expect(bloc.fieldErrors(), {'field': null, 'field2': 'error'});
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should return an empty map when form has no fields',
        build: () => TestFormBloc(),
        verify: (bloc) {
          expect(bloc.fieldErrors(), {});
        },
      );
    });

    group('Reset', () {
      blocTest<TestFormBloc, FormBlocState<String>>(
        'should reset all fields',
        build: () => TestFormBloc(),
        seed: () => FormBlocState<String>(
          fields: {'field': formFieldMock, 'field2': formFieldMock2},
        ),
        act: (bloc) {
          bloc.reset();
        },
        verify: (bloc) {
          verify(() => formFieldMock.reset()).called(1);
          verify(() => formFieldMock2.reset()).called(1);
        },
      );

      blocTest<TestFormBloc, FormBlocState<String>>(
        'should update status to [pure]',
        build: () => TestFormBloc(),
        act: (bloc) {
          bloc.reset();
        },
        expect: () => <FormBlocState<String>>[
          FormBlocState<String>(status: FormStatus.pure)
        ],
      );
    });
  });
}
