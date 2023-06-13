// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_box_bloc.dart';

@immutable
abstract class TextBoxEvent {}

class EmailCheckEvent extends TextBoxEvent {
  String text;
  String? errorText;
  EmailCheckEvent({
    required this.text,
    this.errorText
  });
}
class NameCheckEvent extends TextBoxEvent {
  String text;
  String? errorText;
  NameCheckEvent({
    required this.text,
    this.errorText
  });
}
class SEmailCheckEvent extends TextBoxEvent {
  String text;
  String? errorText;
  SEmailCheckEvent({
    required this.text,
    this.errorText
  });
}

class PasswordCheckEvent extends TextBoxEvent {
  String text;
  String? errorText;
  PasswordCheckEvent({
    required this.text,
     this.errorText
  });
}

class SPasswordCheckEvent extends TextBoxEvent {
  String text;
  String? errorText;
  SPasswordCheckEvent({
    required this.text,
     this.errorText
  });
}

class SignInCheckEvent extends TextBoxEvent {
  String? errorText;
  SignInCheckEvent({
     this.errorText
  });
}
class SSignInCheckEvent extends TextBoxEvent {
  String? errorText;
  SSignInCheckEvent({
     this.errorText
  });
}
class LoginEvent extends TextBoxBloc {
  
}