// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'markers_bloc_bloc.dart';

@immutable
abstract class MarkersBlocState {}

class MarkersBlocInitial extends MarkersBlocState {}
class MarkersBlocLoaded extends MarkersBlocState {
  Set<Marker> markersSet;
  MarkersBlocLoaded({
    required this.markersSet,
  });
}
