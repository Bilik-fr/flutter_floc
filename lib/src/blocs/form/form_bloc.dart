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
}

abstract class FormBloc<Response>
    extends Bloc<FormBlocEvent, FormBlocState<Response>> {
  FormBloc() : super(FormBlocState());

  @override
  Stream<FormBlocState<Response>> mapEventToState(
    FormBlocEvent event,
  ) async* {
    if (event is FormBlocStatusUpdated) {
      yield state.copyWith(status: event.status, response: event.response);
    } else if (event is FormBlocFieldsAdded) {
      yield _mapFormBlocFieldAddedToState(event, state);
    } else if (event is FormBlocFieldUpdated) {
      yield _mapFormBlocFieldUpdatedToState(event, state);
    } else if (event is FormBlocSubmitted) {
      yield* _mapFormBlocSubmittedToState(event, state);
    } else if (event is FormBlocValidated) {
      yield _mapFormBlocValidated(event, state);
    }
  }

  // EVENTS
  Stream<FormBlocState<Response>> _mapFormBlocSubmittedToState(
    FormBlocSubmitted event,
    FormBlocState state,
  ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormStatus.loading);
      onSubmit(state.fields.map((name, field) => MapEntry(name, field.value)));
    } else {
      validate();
    }
  }

  FormBlocState _mapFormBlocValidated(
    FormBlocValidated event,
    FormBlocState state,
  ) {
    final stateSnapshot = state.copyWith();
    return stateSnapshot.copyWith(
        status: _validateFields(stateSnapshot.fields));
  }

  FormBlocState _mapFormBlocFieldUpdatedToState(
    FormBlocFieldUpdated event,
    FormBlocState state,
  ) {
    final FormBlocState stateSnapshot = state.copyWith();

    final currentField = stateSnapshot.fields[event.name];

    if (currentField == null) {
      throw Exception(
        'Error : field `${event.name}` not found. Did you forget to add the field to the form ? (addFields)',
      );
    }

    currentField.setValue(event.value);
    _runFieldsValidation({event.name: currentField}, stateSnapshot.fields);

    return stateSnapshot.copyWith(
      status: _getFieldsStatus(stateSnapshot.fields),
    );
  }

  FormBlocState _mapFormBlocFieldAddedToState(
    FormBlocFieldsAdded event,
    FormBlocState state,
  ) {
    final FormBlocState stateSnapshot = state.copyWith();
    if (event.fields != null && event.fields.length > 0) {
      event.fields.forEach((field) {
        stateSnapshot.fields[field.name] = field;
      });
    }
    return stateSnapshot;
  }

  /// Callback that will run when a form is submitted and validated
  ///
  /// This should be overrided by your FormBloc class
  void onSubmit(Map<String, dynamic> fields);

  /// Submit a form (validation will first be ran)
  void submit() => add(FormBlocSubmitted());

  /// Validate all fields of a FormBloc instance
  void validate() => add(FormBlocValidated());

  /// Add fields to form
  ///
  /// This should be called in the FormBloc constructor
  void addFields(List<FormField> fields) => add(FormBlocFieldsAdded(fields));

  /// Update a field value based on the field name
  void updateField(String name, value) =>
      add(FormBlocFieldUpdated(name, value));

  /// Notify that an success happended during the form submission
  void emitSuccess([Response response]) {
    add(
      FormBlocStatusUpdated<Response>(FormStatus.success, response),
    );
  }

  /// Notify that an error happended during the form submission
  void emitFailure([Response response]) {
    add(
      FormBlocStatusUpdated(FormStatus.failure, response),
    );
  }

  /// Get the error key for a field named [name]
  String fieldError(String name) =>
      state.fields[name] != null ? state.fields[name].error : null;

  /// Get a Map of all fields error
  Map<String, String> fieldErrors() => state.fields.map(
        (key, field) => MapEntry(key, field.error),
      );

  // Executes validation for all given fields and return the new form status
  // Each field is validated only once
  // (performs all fields dependencies validation)
  FormStatus _validateFields(Map<String, FormField> fields) {
    _runFieldsValidation(fields, state.fields);
    return _getFieldsStatus(fields);
  }

  // Return the form status depending on current errors
  FormStatus _getFieldsStatus(Map<String, FormField> fields) {
    return fields.values.every((field) => field.isPure)
        ? FormStatus.pure
        : fields.values.any((field) => field.error != null || field.isPure)
            ? FormStatus.invalid
            : FormStatus.valid;
  }

  // Executes validation for all given fields and all his dependencies
  // Each field is validated only once
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
