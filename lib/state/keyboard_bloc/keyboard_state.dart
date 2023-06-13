part of 'keyboard_bloc.dart';

@immutable
abstract class KeyboardState {}

class KeyboardInitial extends KeyboardState {}
class KeyboardOpenState extends KeyboardState {
  
}
class KeyboardCloseState extends KeyboardState{}