import 'package:flutter/widgets.dart';
import 'package:flutter_floc/flutter_floc.dart';

typedef ValidatorFunction<Value> = String? Function(
    Value value, Map<String, dynamic> fieldSubscriptionValues);

typedef FormBlocListenerCallback<Response> = void Function(
    BuildContext context, FormBlocState<Response> state);
