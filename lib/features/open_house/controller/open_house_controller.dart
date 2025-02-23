import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:layout/models/listing.dart';

class OpenHouseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Listing> listings = <Listing>[].obs;
  DocumentSnapshot? lastDocument;
  RxBool isLoadingListing = false.obs;
  RxBool isLoadingMore = false.obs;

  getOpenHouseListing() async {
    isLoadingListing.value = true;
    try {
      QuerySnapshot<Listing> snapshot = await firestore
          .collection('Listings')
          .where('mapLocation', isNotEqualTo: '')
          .orderBy('propertyId', descending: true)
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
      print('Error $e');
      //Get.snackbar('Error', e.toString());
    }
    isLoadingListing.value = false;
  }
}
