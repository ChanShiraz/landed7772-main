import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'keyboard_event.dart';
part 'keyboard_state.dart';

class KeyboardBloc extends Bloc<KeyboardEvent, KeyboardState> {
  KeyboardBloc() : super(KeyboardInitial()) {
    on<KeyboardEvent>((event, emit) {
      if(event is KeyboardCloseEvent){
        emit(KeyboardCloseState());
      }
      if(event is KeyboardOpenEvent){
        emit(KeyboardOpenState());
      }
    });
  }
}
