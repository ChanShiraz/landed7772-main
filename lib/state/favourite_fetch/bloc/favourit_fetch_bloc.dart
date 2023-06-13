import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../models/listing.dart';

part 'favourit_fetch_event.dart';
part 'favourit_fetch_state.dart';

class FavouritFetchBloc extends Bloc<FavouritFetchEvents, FavouritFetchState> {
  FavouritFetchBloc() : super(FavouritFetchInitial()) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    final allRef = FirebaseFirestore.instance
        .collection('Listings')
        .orderBy('propertyId', descending: true)
        .withConverter(
          fromFirestore: Listing.fromFireStore,
          toFirestore: (value, options) => value.toMap(),
        );
    List<Listing> favListings = [];
    List<Listing> allListings = [];
    final ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Favourites')
        .withConverter(
          fromFirestore: Listing.fromFireStore,
          toFirestore: (value, options) => value.toMap(),
        );
    final checkRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Favourites')
        .limit(1);
    on<FavouritFetchEvent>((event, emit) async {
      if (event is FavouritFetchEvents) {
        favListings = [];
        allListings = [];
        emit(FavouritFetchLoading());
        await allRef.get().then((querySnapshot) {
          for (var element in querySnapshot.docs) {
            final listing = element.data();
            allListings.add(listing);
          }
        });
        await checkRef.get().then((snapShot) async {
          if (snapShot.docs.isNotEmpty) {
            await ref.get().then((snapShot) {
              for (var element in snapShot.docs) {
                final favListing = element.data();
                 for (var allElement in allListings) {
                   if(favListing.propertyId == allElement.propertyId){
                favListings.add(favListing);
                  }
                }
             }
              emit(FavouritFetchLoaded(favListings: favListings));
            });
          } else {
            emit(FavouritFetchEmpty());
          }
        });
      }
  //     if (event is FavouritFetchEvents) {
  //       favListings = [];
  //       await ref.get().then((snapShot) {
  //         for (var element in snapShot.docs) {
  //           final favListing = element.data();
  //           for (var element in allListings) {
  //                 if(favListing.propertyId == element.propertyId){
  //               favListings.add(favListing);
  //                 }
  //               }
  //         }
  //         emit(FavouritFetchLoaded(favListings: favListings));
  //       });
  //     }
     });
   }
}
