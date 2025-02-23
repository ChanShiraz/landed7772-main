import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:layout/models/listing.dart';

class ListingController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Listing> listings = <Listing>[].obs;
  DocumentSnapshot? lastDocument;
  RxBool isLoadingListing = false.obs;
  RxBool isLoadingMore = false.obs;

  @override
  void onInit() async {
     await FirebaseAuth.instance.signInAnonymously();
    super.onInit();
  }

  getListings() async {
    isLoadingListing.value = true;
   // await FirebaseAuth.instance.signInAnonymously();
    try {
      QuerySnapshot<Listing> snapshot = await firestore
          .collection('Listings')
          .orderBy('propertyId', descending: true)
          .limit(10)
          .withConverter(
            fromFirestore: Listing.fromFireStore,
            toFirestore: (value, options) => value.toMap(),
          )
          .get();
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
      }
      for (var element in snapshot.docs) {
        final listingElement = element.data();
        listings.add(listingElement);
      }

      listings.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoadingListing.value = false;
  }

  fetchMoreListings() async {
    final ref = firestore
        .collection('Listings')
        .orderBy('propertyId', descending: true)
        .startAfterDocument(lastDocument!)
        .limit(10)
        .withConverter(
          fromFirestore: Listing.fromFireStore,
          toFirestore: (value, options) => value.toMap(),
        );
    try {
      var querySnapShot = await ref.get();
      if (querySnapShot.docs.isNotEmpty) {
        lastDocument = querySnapShot.docs.last;
        for (var element in querySnapShot.docs) {
          final listingElement = element.data();
          listings.add(listingElement);
        }
      }
      listings.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
