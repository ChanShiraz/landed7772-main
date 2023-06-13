import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'indicator_event.dart';
part 'indicator_state.dart';

class IndicatorBloc extends Bloc<IndicatorEvent, int> {
  IndicatorBloc() : super(0) {
    on<IndicatorEvent>((event, emit) {
      if (event is IndicatorChangeEvent) {
        emit(event.newValue);
      }
      if(event is IndicatorZeroEvent){
        emit(0);
      }
    });
  }
}
