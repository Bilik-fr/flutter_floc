part of 'form_bloc.dart';

class FormBlocState<Response> extends Equatable {
  final FormStatus status;
  final Map<String, FormField> fields;
  final Response? response;

  FormBlocState({
    this.status = FormStatus.pure,
    Map<String, FormField>? fields,
    this.response,
  }) : fields = fields ?? {};

  FormBlocState<Response> copyWith({
    FormStatus? status,
    Map<String, FormField>? fields,
    Response? response,
  }) {
    return FormBlocState<Response>(
      status: status ?? this.status,
      response: response ?? this.response,
      fields: fields ??
          this.fields.map((key, field) => MapEntry(key, field.copyWith())),
    );
  }

  @override
  List<Object> get props => [status, fields];
}
