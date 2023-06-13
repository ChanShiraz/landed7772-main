part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteBlocState {}

class FavouriteBlocInitial extends FavouriteBlocState {}

class FavouriteBlocAddLoading extends FavouriteBlocState {}

class FavouriteBlocAdded extends FavouriteBlocState {}
