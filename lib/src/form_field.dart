import 'package:equatable/equatable.dart';
import 'package:flutter_formbloc/flutter_formbloc.dart';
import 'package:meta/meta.dart';

class FormField<Value> extends Equatable {
  String _name;
  FormInput<Value> _input;
  String _error;
  List<FieldValidator<Value>> validators;
  Value _defaultValue;

  FormField({
    @required String name,
    @required Value defaultValue,
    List<FieldValidator<Value>> validators,
  }) {
    this.validators = validators ?? [];
    this._defaultValue = defaultValue;
    this._name = name;
    this._input = FormInput<Value>(defaultValue);
  }

  FormField<Value> copyWith(
      {String name, Value defaultValue, FieldValidator<Value> validators}) {
    final formField = FormField(
      name: name ?? this._name,
      defaultValue: defaultValue ?? this._defaultValue,
      validators: validators ?? this.validators,
    );
    formField._input = this._input.copyWith();
    formField._error = this._error;
    return formField;
  }

  void setValue(Value value) {
    this._input.setValue(value);
  }

  void setTouched() {
    this._input.setTouched();
  }

  void reset() {
    this._input.reset(this._defaultValue);
  }

  void addValidators(List<FieldValidator<Value>> validators) {
    if (validators != null && validators.length > 0) {
      this.validators.addAll(validators);
    }
  }

  String validate([Map<String, FormField> fieldDependencies]) {
    setTouched();

    if (fieldDependencies == null) {
      fieldDependencies = {};
    }

    if (this.validators != null && this.validators.length > 0) {
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
          validatorFieldDependencies[name] = fieldDependencies[name];
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

  String get name => this._name;
  String get error => this._error;
  Value get defaultValue => this._defaultValue;
  Value get value => this._input.value;
  bool get isTouched => this._input.isTouched();
  bool get isPure => this._input.isPure();

  @override
  List<Object> get props => [_input, _error, validators, _name, _defaultValue];
}
