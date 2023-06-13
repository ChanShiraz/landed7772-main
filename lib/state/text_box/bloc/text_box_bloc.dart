import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'text_box_event.dart';
part 'text_box_state.dart';

class TextBoxBloc extends Bloc<TextBoxEvent, TextBoxState> {
  TextBoxBloc() : super(TextBoxInitial(errorText: null)) {
    on<TextBoxEvent>((event, emit) {
      if (event is EmailCheckEvent) {
        if (event.text.isEmpty) {
          emit(EmailErrorState(errorText: event.errorText));
        } else {
          emit(EmailErrorState(errorText: null));
        }
      }
      if (event is PasswordCheckEvent) {
        if (event.text.isEmpty) {
          emit(PasswordErrorState(errorText: event.errorText));
        } else {
          emit(PasswordErrorState(errorText: null));
        }
      }
      if (event is SignInCheckEvent) {
        if (event.errorText == null) {
          emit(SignInErrorState(errorText: 'Sign In'));
        } else {
          emit(SignInErrorState(errorText: event.errorText!));
        }
      }
      //now for signin text fields
       if (event is NameCheckEvent) {
        if (event.text.isEmpty) {
          emit(NameErrorState(errorText: event.errorText));
        } else {
          emit(NameErrorState(errorText: null));
        }
      }
      if (event is SEmailCheckEvent) {
        if (event.text.isEmpty) {
          emit(SEmailErrorState(errorText: event.errorText));
        } else {
          emit(SEmailErrorState(errorText: null));
        }
      }
      if (event is SPasswordCheckEvent) {
        if (event.text.isEmpty) {
          emit(SPasswordErrorState(errorText: event.errorText));
        } else {
          emit(SPasswordErrorState(errorText: null));
        }
      }
      if (event is SSignInCheckEvent) {
        if (event.errorText == null) {
          emit(SSignInErrorState(errorText: 'Sign In'));
        } else {
          emit(SSignInErrorState(errorText: event.errorText!));
        }
      }
    });
  }
}
