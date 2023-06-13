// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'navbar_bloc.dart';

@immutable
abstract class NavbarEvent {}
@immutable
class NavBarTapEvent extends NavbarEvent {
  int index;
  NavBarTapEvent({
    required this.index,
  });
}
