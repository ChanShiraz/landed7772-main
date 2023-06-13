// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'favourite_check_bloc.dart';

@immutable
abstract class FavouriteCheckEvents {}
class FavouriteCheckEvent extends FavouriteCheckEvents {
  String propertyId;
  FavouriteCheckEvent({
    required this.propertyId,
  });
}
