import 'package:equatable/equatable.dart';
import 'package:flutter_floc/flutter_floc.dart';

class FormField<Value> extends Equatable {
  String _name;
  FormInput<Value> _input;
  String? _error;
  List<FieldValidator<Value>> validators;
  Value _initialValue;

  /// Create a new FormField that could get passed to a FormBloc addFields method
  ///
  /// It could takes a list of validators on the field.
  FormField({
    required String name,
    required Value initialValue,
    List<FieldValidator<Value>>? validators,
  })  : this._initialValue = initialValue,
        this._input = FormInput<Value>(initialValue),
        this._name = name,
        this.validators = validators ?? [];

  FormField<Value> copyWith(
      {String? name,
      Value? initialValue,
      List<FieldValidator<Value>>? validators}) {
    final formField = FormField(
      name: name ?? this._name,
      initialValue: initialValue ?? this._initialValue,
      validators: validators ?? this.validators,
    );
    formField._input = this._input.copyWith();
    formField._error = this._error;
    return formField;
  }

  /// Change the field value
  void setValue(Value value) {
    this._input.setValue(value);
  }

  void setTouched() {
    this._input.setTouched();
  }

  /// Reset the field to its default value
  void reset() {
    this._input.reset(this._initialValue);
  }

  void addValidators(List<FieldValidator<Value>> validators) {
    if (validators.length > 0) {
      this.validators.addAll(validators);
    }
  }

  String? validate([Map<String, FormField> fieldDependencies = const {}]) {
    setTouched();

    if (this.validators.length > 0) {
      for (FieldValidator<Value> validator in validators) {
        final List<String> fieldSubscriptionNames =
            validator.getFieldSubscriptionNames();

        final Map<String, FormField> validatorFieldDependencies = {};
        fieldSubscriptionNames.forEach((name) {
          if (fieldDependencies[name] == null) {
            throw Exception(
              'Error when validating field `$_name` : The field `$name` is missing in dependency.',
            );
          }
          validatorFieldDependencies[name] = fieldDependencies[name]!;
        });

        final validatorsFieldValueDependencies = validatorFieldDependencies
            .map((key, field) => MapEntry(key, field.value));

        this._error =
            validator.run(this._input.value, validatorsFieldValueDependencies);

        if (this._error != null) return this._error;
      }
    }
    return null;
  }

  List<String> getAllFieldSubscriptionNames() {
    List<String> names = [];
    this.validators.forEach((validator) {
      names.addAll(validator.getFieldSubscriptionNames());
    });
    return names;
  }

  /// Get field name
  String get name => this._name;

  // Get field error (String), returns null if there is no error
  String? get error => this._error;

  /// Get default value
  Value get initialValue => this._initialValue;

  /// Get field value
  Value get value => this._input.value;

  /// Return true if the field had been touched, false otherwise
  bool get isTouched => this._input.isTouched();

  @override
  List<Object?> get props => [_input, _error, validators, _name, _initialValue];
}
