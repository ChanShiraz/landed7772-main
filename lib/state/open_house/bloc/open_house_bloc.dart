import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/models/listing.dart';
import 'package:meta/meta.dart';

part 'open_house_event.dart';
part 'open_house_state.dart';

class OpenHouseBloc extends Bloc<OpenHouseEvent, OpenHouseState> {
  OpenHouseBloc() : super(OpenHouseInitial()) {
    final ref = FirebaseFirestore.instance
        .collection('Listings')
        .where('mapLocation', isGreaterThan: '')
        .withConverter(
          fromFirestore: Listing.fromFireStore,
          toFirestore: (value, options) => value.toMap(),
        );
    on<OpenHouseEvent>((event, emit) async {
      List<Listing> mapListing = [];
      var snapshot = await ref.get();
      for (var element in snapshot.docs) {
        mapListing.add(element.data());
      }
      if (event is OpenHouseFetchEvent) {
        emit(OpenHouseLoading());
        for (var element in mapListing) {
          mapListing = mapListing
              .where((element) => element.mapLocation!.isNotEmpty)
              .toList();
        }
        // await ref.get().then((querySanpshot) {
        //   for (var element in querySanpshot.docs) {
        //     final listing = element.data();
        //     mapListing.add(listing);
        //   }
        // });
        emit(OpenHouseLoaded(mapsListings: mapListing));
      }
    });
  }
}
