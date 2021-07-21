import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class FormFieldMock<T> extends Mock implements FormField<T> {}

class ValidatorFunctionMock<T> extends Mock {
  String? call(T value, Map<String, dynamic> fieldSubscriptionValues);
}

void main() {
  late FormField<String> formFieldMock;
  late ValidatorFunction validatorFunction;

  setUp(() {
    formFieldMock = FormFieldMock<String>();
    validatorFunction = (value, fields) => 'validatorFunctionResult';
  });

  group('FieldValidator', () {
    test('should supports value comparison', () {
      expect(
        FieldValidator(validatorFunction, fieldSubscriptions: [formFieldMock]),
        FieldValidator(validatorFunction, fieldSubscriptions: [formFieldMock]),
      );
    });

    test('Initial values', () {
      final validator = FieldValidator(
        validatorFunction,
        fieldSubscriptions: [formFieldMock],
      );

      expect(validator.valitatorFunction, validatorFunction);
      expect(validator.fieldSubscriptions, [formFieldMock]);
    });

    group('Run', () {
      test('should run the validator function with correct params', () {
        final validatorFunctionMock = ValidatorFunctionMock<String>();
        final fieldValidator = FieldValidator<String>(validatorFunctionMock);
        fieldValidator.run('value', {'field2': 'field2'});
        verify(() => validatorFunctionMock('value', {'field2': 'field2'}))
            .called(1);
      });
    });

    group('GetFieldSubscriptionNames', () {
      test('should return all field subscription names', () {
        when(() => formFieldMock.name).thenReturn('field');
        final fieldValidator = FieldValidator<String>(
          validatorFunction,
          fieldSubscriptions: [formFieldMock, formFieldMock],
        );
        expect(fieldValidator.getFieldSubscriptionNames(), ['field', 'field']);
      });

      test(
          'should return an empty list when no field subscriptions are registered',
          () {
        when(() => formFieldMock.name).thenReturn('field');
        final fieldValidator = FieldValidator<String>(validatorFunction);
        expect(fieldValidator.getFieldSubscriptionNames(), []);
      });
    });
  });
}
