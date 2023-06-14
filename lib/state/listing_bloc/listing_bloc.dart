import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:layout/models/listing.dart';
import 'package:meta/meta.dart';

part 'listing_event.dart';
part 'listing_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc() : super(ListingInitial()) {
    final starBuyRef = FirebaseFirestore.instance
        .collection('Listings')
        .where('starBuyListing', isEqualTo: 1)
        .orderBy('timeStamp', descending: true)
        .withConverter(
          fromFirestore: Listing.fromFireStore,
          toFirestore: (value, options) => value.toMap(),
        );
    final ref = FirebaseFirestore.instance
        .collection('Listings')
        .orderBy('propertyId', descending: true)
        .withConverter(
          fromFirestore: Listing.fromFireStore,
          toFirestore: (value, options) => value.toMap(),
        );
    on<ListingEvent>((event, emit) async {
      //sign in annoymously if user is not signed in
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        print("Signed in with temporary account.");
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            print("Anonymous auth hasn't been enabled for this project.");
            break;
          default:
            print("Unknown error.");
        }
      }
      List<Listing> listings = [];
      List<Listing> starBuyListing = [];
      if (event is FetchListingEvent) {
        emit(ListingLoadingState());
        // await starBuyRef.get().then((querySnapshot) {
        //   for (var element in querySnapshot.docs) {
        //     final listing = element.data();
        //     starBuyListing.add(listing);
        //   }
        //   return null;
        // });
        if (FirebaseAuth.instance.currentUser == null) {
          try {
            final userCredential =
                await FirebaseAuth.instance.signInAnonymously();
            print("Signed in with temporary account.");
          } on FirebaseAuthException catch (e) {
            switch (e.code) {
              case "operation-not-allowed":
                print("Anonymous auth hasn't been enabled for this project.");
                break;
              default:
                print("Unknown error.");
            }
          }
        }
        await ref.get().then((querySnapshot) {
          for (var element in querySnapshot.docs) {
            final listing = element.data();
            listings.add(listing);
          }
          starBuyListing =
              listings.where((element) => element.starBuyListing == 1).toList();
        });
        emit(ListingLoadedState(
            listings: listings, starBuyListing: starBuyListing));
      }
    });
  }
}
