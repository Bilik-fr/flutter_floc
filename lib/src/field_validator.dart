import 'package:flutter_formbloc/flutter_formbloc.dart';
import 'package:equatable/equatable.dart';

class FieldValidator<Value> extends Equatable {
  ValidatorFunction<Value> valitatorFunction;
  List<FormField> fieldSubscriptions = [];

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
