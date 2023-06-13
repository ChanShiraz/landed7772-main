// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'favourit_fetch_bloc.dart';

@immutable
abstract class FavouritFetchState {}

class FavouritFetchInitial extends FavouritFetchState {}

class FavouritFetchLoading extends FavouritFetchState {}
class FavouritFetchEmpty extends FavouritFetchState {}

class FavouritFetchLoaded extends FavouritFetchState {
  List<Listing> favListings;
  FavouritFetchLoaded({
    required this.favListings,
  });
}