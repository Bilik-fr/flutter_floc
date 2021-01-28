import 'package:flutter_formbloc/flutter_formbloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormBlocEvent', () {
    group('FormBlocSubmitted', () {
      test('supports value comparisons', () {
        expect(FormBlocSubmitted(), FormBlocSubmitted());
      });
    });

    group('FormBlocFieldsAdded', () {
      test('supports value comparisons', () {
        final FormField field = FormField<String>(
          name: 'field',
          defaultValue: '',
        );
        expect(FormBlocFieldsAdded([field]), FormBlocFieldsAdded([field]));
      });
    });

    group('FormBlocFieldUpdated', () {
      test('supports value comparisons', () {
        expect(
          FormBlocFieldUpdated('field', 'value'),
          FormBlocFieldUpdated('field', 'value'),
        );
      });
    });

    group('FormBlocStatusUpdated', () {
      test('supports value comparisons', () {
        expect(
          FormBlocStatusUpdated(FormStatus.pure, 'response'),
          FormBlocStatusUpdated(FormStatus.pure, 'response'),
        );
      });
    });
  });
}
