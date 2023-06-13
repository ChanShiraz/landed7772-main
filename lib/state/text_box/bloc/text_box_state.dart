// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_box_bloc.dart';

@immutable
abstract class TextBoxState {}

class TextBoxInitial extends TextBoxState {
  String? errorText;
  TextBoxInitial({this.errorText});
}

class EmailErrorState extends TextBoxState {
  String? errorText;
  EmailErrorState({
    this.errorText,
  });
}
class NameErrorState extends TextBoxState {
  String? errorText;
  NameErrorState({
    this.errorText,
  });
}
class SEmailErrorState extends TextBoxState {
  String? errorText;
  SEmailErrorState({
    this.errorText,
  });
}

class PasswordErrorState extends TextBoxState {
  String? errorText;
  PasswordErrorState({
    this.errorText,
  });
}

class SPasswordErrorState extends TextBoxState {
  String? errorText;
  SPasswordErrorState({
    this.errorText,
  });
}

class SignInErrorState extends TextBoxState {
  String errorText;
  SignInErrorState({
    required this.errorText,
  });
  
}
class SSignInErrorState extends TextBoxState {
  String errorText;
  SSignInErrorState({
    required this.errorText,
  });
  
}