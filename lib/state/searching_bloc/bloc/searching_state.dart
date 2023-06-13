// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'searching_bloc.dart';

@immutable
abstract class SearchingState {}

class SearchingInitial extends SearchingState {}
class SearchingEmptyState extends SearchingState {}
class SearchingLoadingState extends SearchingState {}
class SearchingLoadedState extends SearchingState {
  List<Listing> listings;
  SearchingLoadedState({
    required this.listings,
  });
}
