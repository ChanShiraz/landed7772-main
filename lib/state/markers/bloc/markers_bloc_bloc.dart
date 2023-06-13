import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:layout/screens/listing_details.dart';

import '../../../models/listing.dart';

part 'markers_bloc_event.dart';
part 'markers_bloc_state.dart';

class MarkersBloc extends Bloc<MarkersBlocEvent, MarkersBlocState> {
  MarkersBloc() : super(MarkersBlocInitial()) {
    Set<Marker> markers = {};
    on<MarkersBlocEvent>((event, emit) async {
      if (event is CreateMarkerEvent) {
        for (var element in event.mapsListings) {
          try {
            List<Location> locations =
                await locationFromAddress(element.mapLocation!);
            Marker marker = Marker(
                onTap: () {
                  Navigator.of(event.context).push(MaterialPageRoute(
                    builder: (context) => ListingDetailsScreen(
                      listing: element,
                    ),
                  ));
                },
                infoWindow: InfoWindow(title: element.title),
                markerId: MarkerId(element.propertyId),
                position:
                    LatLng(locations[0].latitude, locations[0].longitude));
            markers.add(marker);
          } catch (e) {print(e);}
        }
        emit(MarkersBlocLoaded(markersSet: markers));
        print('markr added in marker bloc$markers');
      }
    });
  }
}
