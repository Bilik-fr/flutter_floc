import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_floc/flutter_floc.dart';

class FormBlocListener<T extends FormBloc<Response>, Response>
    extends BlocListener<T, FormBlocState<Response>> {
  /// Surround child property with a BlocListener which listen on the FormBloc
  ///
  /// This should be declared after the BlocProvider in the widget tree.
  ///
  /// ```dart
  ///BlocProvider(
  ///  create: (context) => ExampleFormBloc(),
  ///  child: FormBlocListener<ExampleFormBloc, String>(
  ///    onSubmitting: (context, state) {},
  ///    onSuccess: (context, state) {},
  ///    onFailure: (context, state) {},
  ///    // Here goes your view, consuming the FormBloc
  ///    child: Text("Hello World!"),
  ///  ),
  ///);
  /// ```
  FormBlocListener({
    Key key,
    this.child,
    this.onSubmitting,
    this.onSuccess,
    this.onFailure,
  }) : super(
          key: key,
          child: child,
          listener: (context, state) {
            if (state.status.isFailure && onFailure != null) {
              onFailure(context, state);
            } else if (state.status.isSuccess && onSuccess != null) {
              onSuccess(context, state);
            } else if (state.status.isLoading && onSubmitting != null) {
              onSubmitting(context, state);
            }
          },
        );

  /// The form child, should probably contains text inputs and submit button.
  final Widget child;

  /// Callback triggered when the form emitted an emitFailure response.
  final FormBlocListenerCallback<Response> onFailure;

  /// Callback triggered when the form emitted an emitSuccess response.
  final FormBlocListenerCallback<Response> onSuccess;

  /// Callback triggered when the form is submitting, helps to manage loading state
  final FormBlocListenerCallback<Response> onSubmitting;
}
