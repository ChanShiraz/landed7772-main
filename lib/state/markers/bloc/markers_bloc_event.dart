// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'markers_bloc_bloc.dart';

@immutable
abstract class MarkersBlocEvent {}
class CreateMarkerEvent extends MarkersBlocEvent{
  final List<Listing> mapsListings;
  BuildContext context;
  CreateMarkerEvent({
    required this.mapsListings,
    required this.context
  });
}
