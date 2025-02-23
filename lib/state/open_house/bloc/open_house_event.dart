part of 'open_house_bloc.dart';

@immutable
abstract class OpenHouseEvent {}

class OpenHouseFetchEvent extends OpenHouseEvent {
  OpenHouseFetchEvent();
}
