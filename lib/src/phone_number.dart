import 'package:phone_form_field/phone_form_field.dart';

class OurPhoneNumber extends PhoneNumber {
  OurPhoneNumber({
    required IsoCode isoCode,
    required String nsn,
  }) : super(isoCode: isoCode, nsn: nsn);
}
