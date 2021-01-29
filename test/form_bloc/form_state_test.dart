import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormBlocState', () {
    test('supports value comparisons', () {
      expect(FormBlocState(), FormBlocState());
    });

    test('returns same object when no properties are passed', () {
      expect(FormBlocState().copyWith(), FormBlocState());
    });

    test('returns object with updated [status] when [status] is passed', () {
      expect(
        FormBlocState<String>().copyWith(status: FormStatus.pure),
        FormBlocState<String>(status: FormStatus.pure),
      );
    });

    test('returns object with updated [response] when [response] is passed',
        () {
      expect(
        FormBlocState<String>().copyWith(response: 'response'),
        FormBlocState<String>(response: 'response'),
      );
    });

    test('returns object with updated [fields] when [fields] is passed', () {
      final FormField field = FormField(
        name: 'username',
        defaultValue: '',
      );
      final Map<String, FormField> fields = {'field': field};

      expect(
        FormBlocState<String>().copyWith(fields: fields),
        FormBlocState<String>(fields: fields),
      );
    });
  });
}
