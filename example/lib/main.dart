import 'package:flutter/material.dart';
import 'package:flutter_floc/flutter_floc.dart';
import 'package:flutter_floc_example/blocs/example_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        child: BlocProvider(
          create: (context) => ExampleFormBloc(),
          child: SingleChildScrollView(child: ExampleForm()),
        ),
      ),
    );
  }
}

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
          TimePickerFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'time',
            format: 'HH:mm',
            decoration: InputDecoration(hintText: 'Time selector'),
            clearable: true,
          ),
          DatePickerFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'date',
            format: 'dd/MM/yyyy',
            decoration: InputDecoration(hintText: 'Date selector'),
            clearable: true,
          ),
          DateRangePickerFieldBlocBuilder<ExampleFormBloc>(
              fieldName: 'dateRange',
              format: 'dd/MM/yyyy',
              decoration: InputDecoration(hintText: 'Date range selector'),
              clearable: true),
          DropdownButtonFormFieldBlocBuilder<ExampleFormBloc, int>(
            fieldName: 'dropdown',
            hint: Text('Select an option'),
            items: [1, 2, 3, 4, 6],
            itemBuilder: (context, item) {
              return DropdownMenuItem(
                child: Text(item.toString()),
                value: item,
              );
            },
          ),
          TextFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'username',
            decoration: InputDecoration(hintText: 'Username'),
          ),
          TextFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'password',
            obscureText: true,
            suffixButton: SuffixButton.obscureText,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          TextFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'confirmPassword',
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm password',
            ),
          ),
          PhoneFormFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'phone',
            decoration: InputDecoration(hintText: 'Phone'),
          ),
          SwitchFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'acceptSwitch',
            body: Text('Accept ?'),
          ),
          CheckboxFieldBlocBuilder<ExampleFormBloc>(
            fieldName: 'acceptCheckbox',
            body: Text('Accept ?'),
          ),
          MaterialButton(
            onPressed: () {
              context.read<ExampleFormBloc>().validate();
            },
            child: Text('Validate'),
          ),
          MaterialButton(
            onPressed: () {
              context.read<ExampleFormBloc>().reset();
            },
            child: Text('Reset'),
          ),
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
