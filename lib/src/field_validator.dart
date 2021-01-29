import 'package:flutter_floc/flutter_floc.dart';
import 'package:equatable/equatable.dart';

class FieldValidator<Value> extends Equatable {
  ValidatorFunction<Value> valitatorFunction;
  List<FormField> fieldSubscriptions = [];

  /// Create a FieldValidator instance that would get passed to a field
  ///
  /// ```dart
  ///FieldValidator(
  ///  validator,
  ///  fieldSubscriptions: [field1, field2, ...],
  ///)
  /// ```
  FieldValidator(this.valitatorFunction, {this.fieldSubscriptions});

  String run(Value value, Map<String, dynamic> fieldSubscriptionValues) {
    return valitatorFunction(value, fieldSubscriptionValues);
  }

  List<String> getFieldSubscriptionNames() {
    return this.fieldSubscriptions != null && this.fieldSubscriptions.length > 0
        ? this.fieldSubscriptions.map((field) => field.name).toList()
        : [];
  }

  @override
  List<dynamic> get props => [valitatorFunction, fieldSubscriptions];
}
