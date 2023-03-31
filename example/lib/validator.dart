import 'package:flutter_floc/flutter_floc.dart';

class Validator {
  static String? required<T extends dynamic>(
      T value, Map<String, dynamic> fields) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return 'required';
    }
    return null;
  }

  static String? min6Chars(String value, Map<String, dynamic> fields) {
    if (value == null || value.isEmpty || value.runes.length < 6) {
      return 'min 6 chars';
    }
    return null;
  }

  static String? confirmPassword(String value, Map<String, dynamic> fields) {
    if (value != fields['password']) {
      return 'different';
    }
    return null;
  }

  static String? phoneValidator<T extends OurPhoneNumber?>(
      T value, Map<String, dynamic> fields) {
    if (value == null || value.nsn.isEmpty) {
      return 'required';
    }
    if (!value.validate()) {
      return 'invalid phone number';
    }

    return null;
  }
}
