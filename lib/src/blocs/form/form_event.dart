part of 'form_bloc.dart';

abstract class FormBlocEvent extends Equatable {
  FormBlocEvent();

  @override
  List<Object?> get props => [];
}

class FormBlocSubmitted extends FormBlocEvent {}

class FormBlocValidated extends FormBlocEvent {}

class FormBlocReset extends FormBlocEvent {}

class FormBlocStatusUpdated<Response> extends FormBlocEvent {
  final FormStatus status;
  final Response? response;

  FormBlocStatusUpdated(this.status, [this.response]);

  @override
  List<Object?> get props => [status, response];
}

class FormBlocFieldsAdded extends FormBlocEvent {
  final List<FormField> fields;

  FormBlocFieldsAdded(this.fields);

  @override
  List<Object> get props => [fields];
}

class FormBlocFieldUpdated extends FormBlocEvent {
  final value;
  final String name;

  FormBlocFieldUpdated(this.name, this.value);

  @override
  List<Object> get props => [name, value];
}
