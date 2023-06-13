import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/screens/listing_details.dart';
import 'package:layout/screens/nav_pages/home_page.dart';
import 'package:layout/state/favourite_fetch/bloc/favourit_fetch_bloc.dart';

class SavedPage extends StatelessWidget {
  SavedPage({super.key});
  late FavouritFetchBloc favouritFetchBloc;
  @override
  Widget build(BuildContext context) {
    favouritFetchBloc = context.read<FavouritFetchBloc>();
    favouritFetchBloc.add(FavouritFetchEvent());
    return SizedBox(
      //height: context.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Saved Listings',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ),
          Expanded(
            child: SizedBox(
              //height: context.height - (kBottomNavigationBarHeight * 3.4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: BlocBuilder(
                  bloc: favouritFetchBloc,
                  builder: (context, state) {
                    if (state is FavouritFetchLoading) {
                      return const FavouriteLoading();
                    } else if (state is FavouritFetchEmpty) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: 50,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Your collection is empty',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black45,
                                fontSize: 16),
                          )
                        ],
                      ));
                    } else if (state is FavouritFetchLoaded) {
                      return ListView.builder(
                        itemCount: state.favListings.length,
                        itemBuilder: (context, index) {
                          return ListingWidget(
                              onClick: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ListingDetailsScreen(
                                      listing: state.favListings[index]),
                                ));
                              },
                              listing: state.favListings[index],
                              showBadge: false);
                        },
                      );
                    }
                    return const Center(child: Text('Some error occured'));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//favourite loading widget
class FavouriteLoading extends StatelessWidget {
  const FavouriteLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => const ShimmerLoading()),
    );
  }
}
