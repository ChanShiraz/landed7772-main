part of 'open_house_bloc.dart';

@immutable
abstract class OpenHouseState {}

class OpenHouseInitial extends OpenHouseState {}

class OpenHouseLoading extends OpenHouseState {}

class OpenHouseLoaded extends OpenHouseState {
  final List<Listing> mapsListings;
  OpenHouseLoaded({required this.mapsListings});
}
