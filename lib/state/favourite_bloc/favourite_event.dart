// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteEvent {}

@immutable
class AddFavouriteEvent extends FavouriteEvent {
  Listing listing;
  AddFavouriteEvent({
    required this.listing,
  });
}

class AddFavouriteIntialEvent extends FavouriteEvent {}
class RemoveFavouriteEvent extends FavouriteEvent {
  String propertyId;
  RemoveFavouriteEvent({
    required this.propertyId,
  });
}
