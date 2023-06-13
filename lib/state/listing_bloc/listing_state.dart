// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'listing_bloc.dart';

@immutable
abstract class ListingState {}

class ListingInitial extends ListingState {}

class ListingLoadingState extends ListingState {}

class ListingLoadedState extends ListingState {
  List<Listing> listings;
  List<Listing> starBuyListing;
  ListingLoadedState({required this.listings, required this.starBuyListing});
}

class StarBuyEmptyState extends ListingState {}
