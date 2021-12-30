import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

part 'form_event.dart';
part 'form_state.dart';

enum FormStatus {
  pure,
  valid,
  invalid,
  loading,
  success,
  failure,
}

extension FormStatusExtension on FormStatus {
  bool get isValidated => <FormStatus>[
        FormStatus.valid,
        FormStatus.loading,
        FormStatus.success,
        FormStatus.failure,
      ].contains(this);

  bool get isPure => FormStatus.pure == this;
  bool get isValid => FormStatus.valid == this;
  bool get isLoading => FormStatus.loading == this;
  bool get isSuccess => FormStatus.success == this;
  bool get isFailure => FormStatus.failure == this;
  bool get isInvalid => FormStatus.invalid == this;
}

abstract class FormBloc<Response>
    extends Bloc<FormBlocEvent, FormBlocState<Response>> {
  FormBloc() : super(FormBlocState<Response>()) {
    on<FormBlocStatusUpdated>(_onFormBlocStatusUpdated);
    on<FormBlocFieldsAdded>(_onFormBlocFieldsAdded);
    on<FormBlocFieldUpdated>(_onFormBlocFieldUpdated);
    on<FormBlocSubmitted>(_onFormBlocSubmitted);
    on<FormBlocValidated>(_onFormBlocValidated);
    on<FormBlocReset>(_onFormBlocReset);
  }

  void _onFormBlocStatusUpdated(
    FormBlocStatusUpdated event,
    Emitter<FormBlocState<Response>> emit,
  ) async {
    emit(state.copyWith(status: event.status, response: event.response));
  }

  // EVENTS
  void _onFormBlocSubmitted(
    FormBlocSubmitted event,
    Emitter<FormBlocState<Response>> emit,
  ) async {
    // Current status
    FormStatus status = state.status;

    // Trigger validation if form is invalid or pure
    if (!status.isValidated) {
      final validatedState = _validate();
      status = validatedState.status; // Manualy update status
      emit(validatedState);
    }
    if (status.isValidated) {
      emit(state.copyWith(status: FormStatus.loading));
      onSubmit(state.fields.map((name, field) => MapEntry(name, field.value)));
    }
  }

  void _onFormBlocValidated(
    FormBlocValidated event,
    Emitter<FormBlocState<Response>> emit,
  ) async {
    emit(_validate());
  }

  void _onFormBlocFieldUpdated(
    FormBlocFieldUpdated event,
    Emitter<FormBlocState<Response>> emit,
  ) async {
    final FormBlocState<Response> stateSnapshot = state.copyWith();

    final currentField = stateSnapshot.fields[event.name];

    if (currentField == null) {
      throw Exception(
        'Error : field `${event.name}` not found. Did you forget to add the field to the form ? (addFields)',
      );
    }

    currentField.setValue(event.value);
    _runFieldsValidation({event.name: currentField}, stateSnapshot.fields);

    emit(stateSnapshot.copyWith(
      status: _getFieldsStatus(stateSnapshot.fields),
    ));
  }

  void _onFormBlocFieldsAdded(
    FormBlocFieldsAdded event,
    Emitter<FormBlocState<Response>> emit,
  ) async {
    final FormBlocState<Response> stateSnapshot = state.copyWith();
    if (event.fields.length > 0) {
      event.fields.forEach((field) {
        stateSnapshot.fields[field.name] = field;
      });
    }
    emit(stateSnapshot);
  }

  void _onFormBlocReset(
    FormBlocReset event,
    Emitter<FormBlocState<Response>> emit,
  ) {
    final stateSnapshot = state.copyWith(status: FormStatus.pure);

    // Reset each field
    stateSnapshot.fields.forEach((fieldName, field) {
      field.reset();
    });
    emit(stateSnapshot);
  }

  // Executes validation for all fields and return the new state
  FormBlocState<Response> _validate() {
    final stateSnapshot = state.copyWith();
    _runFieldsValidation(stateSnapshot.fields, stateSnapshot.fields);
    return stateSnapshot.copyWith(
        status: _getFieldsStatus(stateSnapshot.fields));
  }

  /// Callback that will run when a form is submitted and validated
  ///
  /// This should be overrided by your FormBloc class
  void onSubmit(Map<String, dynamic> fields);

  /// Submit form (validation will first be ran if needed)
  void submit() => add(FormBlocSubmitted());

  /// Validate all fields of a FormBloc instance
  void validate() => add(FormBlocValidated());

  /// Reset form
  void reset() => add(FormBlocReset());

  /// Add fields to form
  ///
  /// This should be called in the FormBloc constructor
  void addFields(List<FormField> fields) => add(FormBlocFieldsAdded(fields));

  /// Update a field value based on the field name
  void updateField(String name, value) =>
      add(FormBlocFieldUpdated(name, value));

  /// Notify that an success happended during the form submission
  void emitSuccess([Response? response]) {
    add(
      FormBlocStatusUpdated<Response>(FormStatus.success, response),
    );
  }

  /// Notify that an error happended during the form submission
  void emitFailure([Response? response]) {
    add(
      FormBlocStatusUpdated(FormStatus.failure, response),
    );
  }

  /// Get the error key for a field named [name]
  String? fieldError(String name) =>
      state.fields[name] != null ? state.fields[name]?.error : null;

  /// Get a Map of all fields error
  Map<String, String?> fieldErrors() => state.fields.map(
        (key, field) => MapEntry(key, field.error),
      );

  // Return the form status depending on current fields status
  FormStatus _getFieldsStatus(Map<String, FormField> fields) {
    // Return [invalid] when any field:
    // - has an error (error != null)
    // - is untouched (because untouched fields have never been validated yet)
    return fields.values.any((field) => field.error != null || !field.isTouched)
        ? FormStatus.invalid
        : FormStatus.valid;
  }

  // Executes validation for all given fields
  // Each field is validated only once
  // (performs all fields dependencies validation)
  void _runFieldsValidation(
      Map<String, FormField> fieldsToValidate, Map<String, FormField> fields) {
    // To remember fields already validated (avoid multiple validation)
    List<String> validatedFields = [];
    fieldsToValidate.forEach((fieldName, field) {
      // Validate field (only if field is not already validated)
      if (!validatedFields.contains(fieldName)) {
        final fieldDependencies = _getFieldDependencies(field, fields);
        field.validate(fieldDependencies);
        validatedFields.add(fieldName);
      }

      // Determine which fields is dependent to the current field
      final Map<String, FormField> dependentFields = {};
      fields.forEach((name, dependentField) {
        // Do not add the current field into the current field dependencies array
        // (a field cannot depend on itself)
        if (name == field.name) {
          return;
        }
        dependentField.validators.forEach((validator) {
          final fieldSubscriptionNames = validator.getFieldSubscriptionNames();
          if (dependentFields[dependentField.name] == null &&
              fieldSubscriptionNames.contains(field.name)) {
            dependentFields[dependentField.name] = dependentField;
          }
        });
      });
      // Executes all dependent fields validation (only if field is not already validated)
      dependentFields.forEach((dependentFieldName, dependentField) {
        if (!validatedFields.contains(dependentFieldName)) {
          final fieldDependencies =
              _getFieldDependencies(dependentField, fields);
          dependentField.validate(fieldDependencies);
          validatedFields.add(dependentFieldName);
        }
      });
    });
  }

  // Return all dependencies for a given field
  Map<String, FormField> _getFieldDependencies(
      FormField field, Map<String, FormField> fields) {
    List<String> allFieldSubscriptionNames =
        field.getAllFieldSubscriptionNames();

    final Map<String, FormField> fieldDependencies =
        fields.map((name, field) => MapEntry(name, field.copyWith()));

    fieldDependencies.removeWhere(
      (name, field) => !allFieldSubscriptionNames.contains(name),
    );

    return fieldDependencies;
  }
}
