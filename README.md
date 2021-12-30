<p align="center">
  <img width="100" src="./assets/logo.png">
</p>

<p align="center">
  <a href="https://codecov.io/gh/Bilik-fr/flutter_floc">
    <img src="https://codecov.io/gh/Bilik-fr/flutter_floc/branch/master/graph/badge.svg?token=FMJOCK4N14"/>
  </a>
</p>

## Introduction

Flutter Floc helps you to create a form within a minute, reducing the boilerplate and providing helpers to link the view to the form state.

## Motivations

Creating forms always had been a repetitive task. In Dart specifically, there are some packages that helps you to reduce the needed boilerplate, for instance:

- [formz](https://pub.dev/packages/formz)
- [flutter_form_bloc](https://pub.dev/packages/flutter_form_bloc)

[formz](https://pub.dev/packages/formz) is a package providing a low-level API to manage an input state.

[flutter_form_bloc](https://pub.dev/packages/flutter_form_bloc) is a package providing a high-level API to manage a form, with validations etc... The thing is, [flutter_form_bloc](https://pub.dev/packages/flutter_form_bloc) [is not maintained anymore](https://github.com/GiancarloCode/form_bloc/issues/192) and is lacking of some functionality, one of them is testing.

We actually needed a strong and testable form manager and we love [bloc](https://github.com/felangel/bloc). For this reason we created our own based on what [flutter_form_bloc](https://pub.dev/packages/flutter_form_bloc) did.

## Getting Started

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

### Installation

Add the `flutter_floc` package to the list of dependency of your Flutter Application (pubspec.yaml):

```dart
dependencies:
  flutter:
    sdk: flutter

  flutter_floc: ^0.0.0-dev.4
```

### Usage

#### Creating a Form BLoC

1. Create a new file named `register_form_bloc.dart` (or whatever you like)
2. Define a class named `RegisterFormBloc` that extends `FormBloc`:

```dart
// FormBloc<String>, String could be replaced
// by whatever form response type you like
class RegisterFormBloc extends FormBloc<String> {

}
```

3. Define the form fields:

```dart
// username is required
static final username = FormField<String>(
  name: 'username',
  initialValue: '',
  validators: [
    FieldValidator(Validator.required),
  ],
);

// password is required and should be contains at least 6 characters
static final password = FormField<String>(
  name: 'password',
  initialValue: '',
  validators: [
    FieldValidator(Validator.required),
    FieldValidator(Validator.min6Chars),
  ],
);

// confirmPassword is required and should have the same value as "password" field
static final confirmPassword = FormField<String>(
  name: 'confirmPassword',
  initialValue: '',
  validators: [
    FieldValidator(Validator.required),
    FieldValidator(
      Validator.confirmPassword,
      fieldSubscriptions: [password],
    ),
  ],
);
```

4. Add fields to the form inside the form constructor:

```dart
class RegisterFormBloc extends FormBloc<String> {
  RegisterFormBloc() {
    addFields([password, username, confirmPassword]);
  }
}
```

5. You can now override the `onSubmit` method that will gets triggered when the form is submitted and valid:

```dart
@override
void onSubmit(fields) async {
  // you can make HTTP calls here for example.
  print(fields['username']);
  print(fields['password']);
  print(fields['confirmPassword']);
  emitSuccess('success response : ok');
}
```

Now let's add some UI to display all these fancy things.

6. Add a `FormBlocListener` (which is based on BlocListener for those who came from the `bloc` package) somewhere in your widgets tree. `FormBlocListener` provide some handlers that gets triggered during the form lifecycle (`onSubmitting`, `onSuccess`, `onFailure`):

```dart
class ExampleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormBlocListener<ExampleFormBloc, String>(
      onSubmitting: (context, state) {
        print('Loading...');
      },
      onSuccess: (context, state) {
        print('Success !');
        print(state.response);
      },
      onFailure: (context, state) {
        print('Failure !');
        print(state.response);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Field are inside a TextFieldBlocBuilder
          // that gets updated when the field state change.
          TextFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'username',
            decoration: InputDecoration(hintText: 'Username'),
          ),
          TextFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'password',
            obscureText: true,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          TextFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'confirmPassword',
            obscureText: true,
            decoration: InputDecoration(hintText: 'Confirm password'),
          ),
          // Button that force fields validation.
          MaterialButton(
            onPressed: () {
              context.read<ExampleFormBloc>().validate();
            },
            child: Text('Validate'),
          ),
          // Button that triggers a submit on the form.
          MaterialButton(
            onPressed: () {
              context.read<ExampleFormBloc>().submit();
            },
            child: Text('Submit'),
          )
        ],
      ),
    );
  }
}
```

That's it! You've made your first FormBLoC.

## Validators

You can create simple validators, for example a 6minchars validator like this :

```dart
String min6Chars(String value, Map<String, dynamic> fields) {
  if (value == null || value.isEmpty || value.runes.length < 6) {
    return 'min 6 chars';
  }
  return null;
}
```

The return value is null if there is no error. Else it's a string where the return value is considered as the `error key` that will gets passed to the UI.

To add this validator to a field, simply add it to the field list validators:

```dart
static final 6minField = FormField<String>(
  name: '6minField',
  initialValue: '',
  validators: [
    FieldValidator(min6Chars),
  ],
);

```

## Validators that depends on other value (confirm password case)

A validator can depends on other fields value :

```dart
String confirmPassword(String value, Map<String, dynamic> fields) {
  if (value != fields['password']) {
    return 'different';
  }
  return null;
}
```

The second `fields` parameter contains the dependent fields. To add a dependency to a validator, simply define them into the validator `fieldSubscriptions` named parameter of confirmPassword:

```dart
static final confirmPassword = FormField<String>(
  name: 'confirmPassword',
  initialValue: '',
  validators: [
    FieldValidator(Validator.required),
    FieldValidator(
      Validator.confirmPassword,
      // We can add other fields here
      fieldSubscriptions: [password],
    ),
  ],
);
```

## Testing your form

TODO

## Maintainers

[Christopher Grossain](https://github.com/kaw7413)
