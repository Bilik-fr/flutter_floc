import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_formbloc/flutter_formbloc.dart';

class FormBlocListener<T extends FormBloc<Response>, Response>
    extends BlocListener<T, FormBlocState<Response>> {
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

  final Widget child;

  final FormBlocListenerCallback<Response> onFailure;
  final FormBlocListenerCallback<Response> onSuccess;
  final FormBlocListenerCallback<Response> onSubmitting;
}
