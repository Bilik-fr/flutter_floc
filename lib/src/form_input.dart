import 'package:equatable/equatable.dart';

class FormInput<Value> extends Equatable {
  bool _touched = false;
  Value _value;

  FormInput(this._value);

  FormInput<Value> copyWith({Value value}) {
    final formInput = FormInput(value ?? this._value);
    formInput._touched = this._touched;
    return formInput;
  }

  void reset(Value value) {
    this._touched = false;
    this._value = value;
  }

  void setValue(Value value) {
    setTouched();
    this._value = value;
  }

  void setTouched() {
    this._touched = true;
  }

  Value get value => this._value;

  bool isTouched() => this._touched;

  @override
  List<Object> get props => [_value, _touched];
}
