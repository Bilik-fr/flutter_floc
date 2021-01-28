import 'package:flutter_formbloc/flutter_formbloc.dart';
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

    test('IsPure', () {
      expect(formInput.isPure(), true);
      formInput.setValue('value');
      expect(formInput.isPure(), false);
    });

    test('Initial values', () {
      expect(formInput.value, 'value');
      expect(formInput.isPure(), true);
      expect(formInput.isTouched(), false);
    });

    test('SetValue', () {
      formInput.setValue('value2');

      expect(formInput.value, 'value2');
      expect(formInput.isPure(), false);
      expect(formInput.isTouched(), true);
    });

    test('SetTouched', () {
      formInput.setTouched();
      expect(formInput.isPure(), true);
      expect(formInput.isTouched(), true);
    });

    test('Reset', () {
      formInput.reset('value');
      expect(formInput.value, 'value');
      expect(formInput.isPure(), true);
      expect(formInput.isTouched(), false);
    });
  });
}
