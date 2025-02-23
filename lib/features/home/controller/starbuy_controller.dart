import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:layout/models/listing.dart';

class StarBuyController extends GetxController {
  RxList<Listing> starListings = <Listing>[].obs;
  DocumentSnapshot? lastDocument;
  RxBool isLoadingListing = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getListings() async {
    isLoadingListing.value = true;
    try {
      QuerySnapshot<Listing> snapshot = await firestore
          .collection('Listings')
          .orderBy('propertyId', descending: true)
          .where('starBuyListing', isEqualTo: 1)
          .limit(3)
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
        starListings.add(listingElement);
      }

      isLoadingListing.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoadingListing.value = false;
  }

  getAllStarListings() async {
    isLoadingListing.value = true;
    try {
      QuerySnapshot<Listing> snapshot = await firestore
          .collection('Listings')
          .orderBy('propertyId', descending: true)
          .where('starBuyListing', isEqualTo: 1)
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
        starListings.add(listingElement);
      }

      isLoadingListing.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoadingListing.value = false;
  }

  fetchMoreListings() async {
    print('called');
    final ref = firestore
        .collection('Listings')
        .orderBy('propertyId', descending: true)
        .where('starBuyListing', isEqualTo: 1)
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
          starListings.add(listingElement);
        }
      }
      print(starListings.length);
      starListings.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
