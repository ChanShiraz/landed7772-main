import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/state/markers/bloc/markers_bloc_bloc.dart';
import 'package:layout/state/open_house/bloc/open_house_bloc.dart';

class OpenHousePage extends StatefulWidget {
  const OpenHousePage({super.key});

  @override
  _OpenHouseState createState() => _OpenHouseState();
}

class _OpenHouseState extends State<OpenHousePage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(1.3521, 103.8198);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  List<Marker> markers = [];
  late OpenHouseBloc openHouseBloc;
  late MarkersBloc markersBloc;
  @override
  Widget build(BuildContext context) {
    openHouseBloc = context.read<OpenHouseBloc>();
    markersBloc = context.read<MarkersBloc>();
    openHouseBloc.add(OpenHouseFetchEvent());
    return Scaffold(
        body: BlocBuilder(
      bloc: openHouseBloc,
      builder: (context, state) {
        if (state is OpenHouseLoading) {
          return const CircularProgressIndicator();
        } else if (state is OpenHouseLoaded) {
          markersBloc.add(CreateMarkerEvent(
              mapsListings: state.mapsListings, context: context));
          return BlocBuilder(
            bloc: markersBloc,
            builder: (context, state) {
              if (state is MarkersBlocLoaded) {
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  markers: state.markersSet,
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height * 0.4,
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            },
          );
        } else {
          return const Text('Some Error');
        }
      },
    ));
  }

  Future<Location> getLat(String address) async {
    List<Location> locations =
        await locationFromAddress('Eidgah Wali, Lodhran, Punjab, Pakistan');
    return locations[0];
  }
}
