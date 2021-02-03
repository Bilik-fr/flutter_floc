import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FieldValidatorMock<T> extends Mock implements FieldValidator<T> {}

void main() {
  FieldValidatorMock<String> fieldValidatorMock;
  FieldValidatorMock<String> fieldValidatorMock2;

  setUp(() {
    fieldValidatorMock = FieldValidatorMock<String>();
    fieldValidatorMock2 = FieldValidatorMock<String>();
  });

  group('FormField', () {
    test('should supports value comparison', () {
      expect(
        FormField<String>(name: 'field', defaultValue: ''),
        FormField<String>(name: 'field', defaultValue: ''),
      );
    });

    test('CopyWith should return a copy of the object with same values', () {
      expect(
        FormField<String>(name: 'field', defaultValue: ''),
        FormField<String>(name: 'field', defaultValue: '').copyWith(),
      );
    });

    test('Initial values', () {
      final formField = FormField<String>(
        name: 'field',
        defaultValue: 'value',
        validators: [fieldValidatorMock],
      );

      expect(formField.name, 'field');
      expect(formField.defaultValue, 'value');
      expect(formField.error, null);
      expect(formField.validators, [fieldValidatorMock]);
      expect(formField.value, 'value');
      expect(formField.isTouched, false);
    });

    test('SetValue', () {
      final formField = FormField<String>(name: 'field', defaultValue: '');
      final fieldValue = 'value';
      formField.setValue(fieldValue);
      expect(formField.value, fieldValue);
      expect(formField.isTouched, true);
    });

    test('SetTouched', () {
      final formField = FormField<String>(name: 'field', defaultValue: '');
      formField.setTouched();
      expect(formField.isTouched, true);
    });

    test('Reset', () {
      final fieldValue = 'value';
      final formField =
          FormField<String>(name: 'field', defaultValue: fieldValue);
      formField.setValue('newValue');
      formField.reset();
      expect(formField.value, fieldValue);
      expect(formField.isTouched, false);
    });

    test('AddValidators', () {
      final formField = FormField<String>(name: 'field', defaultValue: '');
      formField.addValidators([fieldValidatorMock]);
      expect(formField.validators, [fieldValidatorMock]);
    });

    test('GetAllFieldSubscriptionNames', () {
      when(fieldValidatorMock.getFieldSubscriptionNames()).thenReturn(
        ['field1', 'field2'],
      );

      final formField = FormField<String>(
        name: 'field3',
        defaultValue: '',
        validators: [fieldValidatorMock],
      );
      expect(formField.getAllFieldSubscriptionNames(), ['field1', 'field2']);
    });

    group('Validate', () {
      test('should set touched the field', () {
        final formField = FormField<String>(name: 'field', defaultValue: '');
        formField.validate();
        expect(formField.isTouched, true);
      });

      test('should return [null] when field doesnt have any validators', () {
        final formField = FormField<String>(name: 'field', defaultValue: '');
        expect(formField.validate(), null);
        expect(formField.error, null);
      });

      test('should run all field validators', () {
        when(fieldValidatorMock.getFieldSubscriptionNames()).thenReturn([]);
        when(fieldValidatorMock2.getFieldSubscriptionNames()).thenReturn([]);

        final formField = FormField<String>(
          name: 'field',
          defaultValue: '',
          validators: [fieldValidatorMock, fieldValidatorMock2],
        );

        formField.validate();
        verify(fieldValidatorMock.run('', {})).called(1);
        verify(fieldValidatorMock2.run('', {})).called(1);
      });

      test('should store the first validators error', () {
        when(fieldValidatorMock.getFieldSubscriptionNames()).thenReturn([]);
        when(fieldValidatorMock2.getFieldSubscriptionNames()).thenReturn([]);

        when(fieldValidatorMock.run(any, any)).thenReturn('error');
        when(fieldValidatorMock2.run(any, any)).thenReturn('error2');

        final formField = FormField<String>(
          name: 'field',
          defaultValue: '',
          validators: [fieldValidatorMock, fieldValidatorMock2],
        );

        formField.validate();
        expect(formField.error, 'error');

        when(fieldValidatorMock.run(any, any)).thenReturn(null);
        formField.validate();
        expect(formField.error, 'error2');
      });

      test('should throw an error when a dependency is missing', () {
        when(fieldValidatorMock.getFieldSubscriptionNames()).thenReturn(
          ['field2'],
        );

        final formField = FormField<String>(
          name: 'field',
          defaultValue: '',
          validators: [fieldValidatorMock],
        );
        expect(() => formField.validate(), throwsException);
      });

      test('should provide field dependencies values to validator function',
          () {
        when(fieldValidatorMock.getFieldSubscriptionNames()).thenReturn(
          ['field2'],
        );

        final formField = FormField<String>(
          name: 'field',
          defaultValue: 'value',
          validators: [fieldValidatorMock],
        );

        final formField2 = FormField<String>(
          name: 'field2',
          defaultValue: 'value2',
        );

        formField.validate({'field2': formField2});

        verify(fieldValidatorMock.run('value', {'field2': 'value2'})).called(1);
      });
    });
  });
}
