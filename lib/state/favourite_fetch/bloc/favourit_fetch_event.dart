part of 'favourit_fetch_bloc.dart';

@immutable
abstract class FavouritFetchEvents {}

class FavouritFetchEvent extends FavouritFetchEvents {}
class FavouritUpdateEvent extends FavouritFetchEvent{}
