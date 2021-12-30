import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FieldValidatorMock<T> extends Mock implements FieldValidator<T> {}

void main() {
  late FieldValidatorMock<String> fieldValidatorMock;
  late FieldValidatorMock<String> fieldValidatorMock2;

  setUp(() {
    fieldValidatorMock = FieldValidatorMock<String>();
    fieldValidatorMock2 = FieldValidatorMock<String>();
  });

  group('FormField', () {
    test('should supports value comparison', () {
      expect(
        FormField<String>(name: 'field', initialValue: ''),
        FormField<String>(name: 'field', initialValue: ''),
      );
    });

    test('CopyWith should return a copy of the object with same values', () {
      expect(
        FormField<String>(name: 'field', initialValue: ''),
        FormField<String>(name: 'field', initialValue: '').copyWith(),
      );
    });

    test('Initial values', () {
      final formField = FormField<String>(
        name: 'field',
        initialValue: 'value',
        validators: [fieldValidatorMock],
      );

      expect(formField.name, 'field');
      expect(formField.initialValue, 'value');
      expect(formField.error, null);
      expect(formField.validators, [fieldValidatorMock]);
      expect(formField.value, 'value');
      expect(formField.isTouched, false);
    });

    test('SetValue', () {
      final formField = FormField<String>(name: 'field', initialValue: '');
      final fieldValue = 'value';
      formField.setValue(fieldValue);
      expect(formField.value, fieldValue);
      expect(formField.isTouched, true);
    });

    test('SetTouched', () {
      final formField = FormField<String>(name: 'field', initialValue: '');
      formField.setTouched();
      expect(formField.isTouched, true);
    });

    test('AddValidators', () {
      final formField = FormField<String>(name: 'field', initialValue: '');
      formField.addValidators([fieldValidatorMock]);
      expect(formField.validators, [fieldValidatorMock]);
    });

    test('GetAllFieldSubscriptionNames', () {
      when(() => fieldValidatorMock.getFieldSubscriptionNames()).thenReturn(
        ['field1', 'field2'],
      );

      final formField = FormField<String>(
        name: 'field3',
        initialValue: '',
        validators: [fieldValidatorMock],
      );
      expect(formField.getAllFieldSubscriptionNames(), ['field1', 'field2']);
    });

    test('Reset', () {
      when(() => fieldValidatorMock.run(any(), any())).thenReturn('error');

      final fieldValue = 'value';
      final formField = FormField<String>(
        name: 'field',
        initialValue: fieldValue,
        validators: [fieldValidatorMock],
      );

      formField.setValue('newValue');
      formField.reset();
      expect(formField.value, fieldValue);
      expect(formField.error, null);
      expect(formField.isTouched, false);
    });

    group('Validate', () {
      test('should set touched the field', () {
        final formField = FormField<String>(name: 'field', initialValue: '');
        formField.validate();
        expect(formField.isTouched, true);
      });

      test('should return [null] when field doesnt have any() validators', () {
        final formField = FormField<String>(name: 'field', initialValue: '');
        expect(formField.validate(), null);
        expect(formField.error, null);
      });

      test('should run all field validators', () {
        when(() => fieldValidatorMock.getFieldSubscriptionNames())
            .thenReturn([]);
        when(() => fieldValidatorMock2.getFieldSubscriptionNames())
            .thenReturn([]);

        final formField = FormField<String>(
          name: 'field',
          initialValue: '',
          validators: [fieldValidatorMock, fieldValidatorMock2],
        );

        formField.validate();
        verify(() => fieldValidatorMock.run('', {})).called(1);
        verify(() => fieldValidatorMock2.run('', {})).called(1);
      });

      test('should store the first validators error', () {
        when(() => fieldValidatorMock.getFieldSubscriptionNames())
            .thenReturn([]);
        when(() => fieldValidatorMock2.getFieldSubscriptionNames())
            .thenReturn([]);

        when(() => fieldValidatorMock.run(any(), any())).thenReturn('error');
        when(() => fieldValidatorMock2.run(any(), any())).thenReturn('error2');

        final formField = FormField<String>(
          name: 'field',
          initialValue: '',
          validators: [fieldValidatorMock, fieldValidatorMock2],
        );

        formField.validate();
        expect(formField.error, 'error');

        when(() => fieldValidatorMock.run(any(), any())).thenReturn(null);
        formField.validate();
        expect(formField.error, 'error2');
      });

      test('should throw an error when a dependency is missing', () {
        when(() => fieldValidatorMock.getFieldSubscriptionNames()).thenReturn(
          ['field2'],
        );

        final formField = FormField<String>(
          name: 'field',
          initialValue: '',
          validators: [fieldValidatorMock],
        );
        expect(() => formField.validate(), throwsException);
      });

      test('should provide field dependencies values to validator function',
          () {
        when(() => fieldValidatorMock.getFieldSubscriptionNames()).thenReturn(
          ['field2'],
        );

        final formField = FormField<String>(
          name: 'field',
          initialValue: 'value',
          validators: [fieldValidatorMock],
        );

        final formField2 = FormField<String>(
          name: 'field2',
          initialValue: 'value2',
        );

        formField.validate({'field2': formField2});

        verify(() => fieldValidatorMock.run('value', {'field2': 'value2'}))
            .called(1);
      });
    });
  });
}
