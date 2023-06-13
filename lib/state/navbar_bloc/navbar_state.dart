// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'navbar_bloc.dart';

@immutable
abstract class NavbarState {}

class NavbarInitial extends NavbarState {}
class NavbarChangeState extends NavbarState {
  int index;
  NavbarChangeState({
    required this.index,
  });
}
