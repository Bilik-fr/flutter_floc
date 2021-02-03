import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FormInput<String> formInput;

  setUp(() {
    formInput = FormInput<String>('value');
  });

  group('FormInput', () {
    test('should supports value comparisons', () {
      expect(FormInput<String>('value'), FormInput<String>('value'));
    });

    test('CopyWith should return a copy of the object with same values', () {
      expect(FormInput<String>('value'), FormInput<String>('value').copyWith());
    });

    test('IsTouched', () {
      expect(formInput.isTouched(), false);
      formInput.setTouched();
      expect(formInput.isTouched(), true);
    });

    test('Initial values', () {
      expect(formInput.value, 'value');
      expect(formInput.isTouched(), false);
    });

    test('SetValue', () {
      formInput.setValue('value2');

      expect(formInput.value, 'value2');
      expect(formInput.isTouched(), true);
    });

    test('SetTouched', () {
      formInput.setTouched();
      expect(formInput.isTouched(), true);
    });

    test('Reset', () {
      formInput.reset('value');
      expect(formInput.value, 'value');
      expect(formInput.isTouched(), false);
    });
  });
}
