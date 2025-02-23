import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/models/listing.dart';
import 'package:meta/meta.dart';

part 'searching_event.dart';
part 'searching_state.dart';

class SearchingBloc extends Bloc<SearchingEvent, SearchingState> {
  SearchingBloc() : super(SearchingInitial()) {
    on<SearchingEvent>((event, emit) async {
      List<Listing> fetchedList = [];
      emit(SearchingLoadingState());
      //if user give both prices
      if (event.startPrice != null && event.endPrice != null) {
        var ref = FirebaseFirestore.instance
            .collection('Listings')
            .where('price', isGreaterThanOrEqualTo: event.startPrice)
            .where('price', isLessThanOrEqualTo: event.endPrice)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await ref.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
        //if user only gives start price
      } else if (event.startPrice != null) {
        var ref = FirebaseFirestore.instance
            .collection('Listings')
            .where('price', isGreaterThanOrEqualTo: event.startPrice)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await ref.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            //print(element.data());
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
      }
      //if user only gives end price
      else if (event.endPrice != null) {
        var ref = FirebaseFirestore.instance
            .collection('Listings')
            .where('price', isLessThanOrEqualTo: event.endPrice)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await ref.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
      }
      //if user only select property type
      else if (event.propertyTypesList != null &&
          event.propertyTypesList!.isNotEmpty) {
        var query = FirebaseFirestore.instance
            .collection('Listings')
            .where('propertyType', whereIn: event.propertyTypesList)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await query.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
      } else if (event.noOfBedRoomsList != null &&
          event.noOfBedRoomsList!.isNotEmpty) {
        List<int> list = [];
        for (var element in event.noOfBedRoomsList!) {
          if (element == '10+') {
            list.add(10);
          } else {
            list.add(int.parse(element));
          }
        }
        var query = FirebaseFirestore.instance
            .collection('Listings')
            .where('noOfBedRooms', whereIn: list)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await query.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
      }
      //if user only select for sale or rent
      else if (event.forSaleList != null && event.forSaleList!.isNotEmpty) {
        var query = FirebaseFirestore.instance
            .collection('Listings')
            .where('forSale', whereIn: event.forSaleList)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await query.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
      }
      //only condition
      else if (event.conditionList != null && event.conditionList!.isNotEmpty) {
        var query = FirebaseFirestore.instance
            .collection('Listings')
            .where('conditon', whereIn: event.conditionList)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await query.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
      }

      //if user only select district
      else if (event.districtList != null && event.districtList!.isNotEmpty) {
        var query = FirebaseFirestore.instance
            .collection('Listings')
            .where('district', whereIn: event.districtList)
            .withConverter(
              fromFirestore: Listing.fromFireStore,
              toFirestore: (value, options) => value.toMap(),
            );
        await query.get().then((querySnapShot) {
          for (var element in querySnapShot.docs) {
            final listing = element.data();
            fetchedList.add(listing);
          }
        });
      }

      List<Listing> filteredList = List.from(fetchedList);

      if (event.startPrice != null) {
        filteredList = filteredList
            .where((element) => element.price >= event.startPrice!)
            .toList();
      }

      if (event.endPrice != null) {
        filteredList = filteredList
            .where((element) => element.price <= event.endPrice!)
            .toList();
      }

      if (event.propertyTypesList != null &&
          event.propertyTypesList!.isNotEmpty) {
        var propertyTypes = event.propertyTypesList!
            .map((e) => e)
            .toSet(); // create a set of property types
        filteredList = filteredList
            .where((element) => propertyTypes.contains(element.propertyType))
            .toList();
      }

      if (event.noOfBedRoomsList != null &&
          event.noOfBedRoomsList!.isNotEmpty) {
        var bedRooms = event.noOfBedRoomsList!
            .map((e) => e.toString())
            .toSet(); // create a set of bedroom types
        filteredList = filteredList
            .where(
                (element) => bedRooms.contains(element.noOfBedRooms.toString()))
            .toList();
      }

      if (event.forSaleList != null && event.forSaleList!.isNotEmpty) {
        var forSaleList = event.forSaleList!
            .map((e) => e.toString())
            .toSet(); // create a set of bedroom types
        filteredList = filteredList
            .where(
                (element) => forSaleList.contains(element.forSale.toString()))
            .toList();
      }
      if (event.conditionList != null && event.conditionList!.isNotEmpty) {
        var forSaleList = event.conditionList!
            .map((e) => e.toString())
            .toSet(); // create a set of bedroom types
        filteredList = filteredList
            .where(
                (element) => forSaleList.contains(element.conditon.toString()))
            .toList();
      }
      if (event.districtList != null && event.districtList!.isNotEmpty) {
        var districtList = event.districtList!.map((e) => e.toString()).toSet();
        print(districtList);
        // create a set of bedroom types
        filteredList = filteredList
            .where(
                (element) => districtList.contains(element.district.toString()))
            .toList();
        print(filteredList);
      }
      if (filteredList.isNotEmpty) {
        emit(SearchingLoadedState(listings: filteredList));
      } else {
        emit(SearchingEmptyState());
      }
    });
  }
}

// if (event.propertyTypesList!.isNotEmpty &&
//     event.noOfBedRoomsList!.isNotEmpty &&
//     event.forSaleList!.isNotEmpty &&
//     event.startPrice != null &&
//     event.endPrice != null) {
//   Query query = FirebaseFirestore.instance
//       .collection('Listings')
//       .where('propertyType', whereIn: event.propertyTypesList)
//       .where('noOfBedRooms', whereIn: [5,6]);
//       // .where('forSale', whereIn: event.forSaleList)
//       // .where('price', isGreaterThanOrEqualTo: event.forSaleList)
//       // .where('price', isLessThanOrEqualTo: event.endPrice);
//   await query.get().then((querySnapShot) {
//     for (var docSnapshot in querySnapShot.docs) {
//       print('${docSnapshot.id} => ${docSnapshot.data()}');
//     }
//   });
//}
