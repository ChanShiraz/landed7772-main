part of 'favourite_check_bloc.dart';

@immutable
abstract class FavouriteCheckState {}

class FavouriteCheckInitial extends FavouriteCheckState {}
class FavouriteCheckPresent extends FavouriteCheckState {}
class FavouriteCheckNull extends FavouriteCheckState {}
