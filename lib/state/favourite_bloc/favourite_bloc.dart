import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layout/models/listing.dart';
import 'package:meta/meta.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteBlocState> {
  FavouriteBloc() : super(FavouriteBlocInitial()) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    on<FavouriteEvent>((event, emit) async {
      final User user = auth.currentUser!;
      final uid = user.uid;
      final ref = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Favourites');
          
      if (event is AddFavouriteEvent) {
        emit(FavouriteBlocAddLoading());
        await ref
            .doc(event.listing.propertyId)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) {
                return value.toMap();
              },
            )
            .set(event.listing)
            .then((value) {
          emit(FavouriteBlocAdded());
          return null;
        });
      }
      if (event is RemoveFavouriteEvent) {
        ref.doc(event.propertyId).delete();
      }
      if (event is AddFavouriteIntialEvent) {
        emit(FavouriteBlocInitial());
      }
    });
  }
}
