import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navbar_event.dart';
part 'navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, int> {
  NavbarBloc() : super(0) {
    on<NavbarEvent>((event, emit) {
     if(event is NavBarTapEvent){
      emit(event.index);
     }
    });
  }
}
