// ignore_for_file: camel_case_types, avoid_types_as_parameter_names
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/counter/cubit/states.dart';

class counterCubit extends Cubit<counterStates> {
  counterCubit(super.counterInitialState);
  int counter = 1;
  static counterCubit get(context) => BlocProvider.of(context);

  void minus() {
    counter--;
    emit(counterMinusState(counter));
  }

  void plus() {
    counter++;
    emit(counterPlusState(counter));
  }
}
