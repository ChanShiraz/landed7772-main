part of 'open_house_bloc.dart';

@immutable
abstract class OpenHouseEvent {}

class OpenHouseFetchEvent extends OpenHouseEvent {
  List<Listing>mapListings;
  OpenHouseFetchEvent({required this.mapListings});
}
