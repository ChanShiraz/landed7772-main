import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:layout/costants/colors.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/models/listing.dart';
import 'package:layout/state/favourite_bloc/favourite_bloc.dart';
import 'package:layout/state/favourite_check/bloc/favourite_check_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../state/bloc/indicator_bloc.dart';
import '../state/favourite_fetch/bloc/favourit_fetch_bloc.dart';

class ListingDetailsScreen extends StatelessWidget {
  ListingDetailsScreen({super.key, required this.listing});
  final Listing listing;
  List<String>? images;
  int activePage = 0;
  late IndicatorBloc indicatorBloc;
  late FavouriteBloc favouriteBloc;
  late FavouritFetchBloc favouritFetchBloc;
  late FavouriteCheckBloc favouriteCheckBloc;
  @override
  Widget build(BuildContext context) {
    indicatorBloc = context.read<IndicatorBloc>();
    favouriteBloc = context.read<FavouriteBloc>();
    favouritFetchBloc = context.read<FavouritFetchBloc>();
    favouriteCheckBloc = context.read<FavouriteCheckBloc>();
    favouriteCheckBloc.add(FavouriteCheckEvent(propertyId: listing.propertyId));
    indicatorBloc.add(IndicatorZeroEvent());

    images = [];
    images!.add(listing.featuredImageUrl);
    if (listing.optionalImage1 != null) {
      images!.add(listing.optionalImage1!);
    }
    if (listing.optionalImage2 != null) {
      images!.add(listing.optionalImage2!);
    }
    if (listing.optionalImage3 != null) {
      images!.add(listing.optionalImage3!);
    }
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Stack(
                    children: [
                      Container(
                        height: context.height * 0.3,
                        color: Colors.grey,
                        child: Stack(
                          children: [
                            PageView.builder(
                              itemCount: images!.length,
                              pageSnapping: true,
                              onPageChanged: (value) {
                                //set state here
                                indicatorBloc
                                    .add(IndicatorChangeEvent(newValue: value));
                              },
                              itemBuilder: (context, index) {
                                return Image.network(
                                  images![index],
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: BlocBuilder(
                                    bloc: indicatorBloc,
                                    builder: (context, state) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: indicators(
                                            images!.length, state as int),
                                      );
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                            BlocBuilder(
                              bloc: favouriteCheckBloc,
                              builder: (context, state) {
                                if (state is FavouriteCheckPresent) {
                                  return IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              RemoveFavouriteDialouge(
                                                  favouriteBloc: favouriteBloc,
                                                  listing: listing,
                                                  favouritFetchBloc:
                                                      favouritFetchBloc,
                                                  favouriteCheckBloc:
                                                      favouriteCheckBloc),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                      ));
                                } else {
                                  return IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => FavouriteDialouge(
                                          favouritFetchBloc: favouritFetchBloc,
                                          favouriteBloc: favouriteBloc,
                                          listing: listing,
                                          favouriteCheckBloc:
                                              favouriteCheckBloc,
                                        ),
                                      );
                                      // favouriteBloc
                                      //     .add(AddFavouriteEvent(listing: listing));
                                    },
                                    icon: const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'For ${listing.forSale}',
                          style: const TextStyle(
                              color: AppColor.primaryBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '\$${NumberFormat("#,##0", "en_US").format(listing.price)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoomsWidget(
                            icons: Icons.bed,
                            text: '${listing.noOfBedRooms} Bedrooms',
                          ),
                          RoomsWidget(
                            icons: Icons.bathtub_outlined,
                            text: '${listing.noOfBathRooms} Bathrooms',
                          ),
                          RoomsWidget(
                              icons: Icons.place_outlined,
                              text: listing.district),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Details',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      DetailsWidget(listing: listing),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(listing.description),
                      const SizedBox(
                        height: 10,
                      ),
                      listing.youtubeLink!.length > 2
                          ? InkWell(
                              onTap: () async {
                                Uri uri = Uri.parse(listing.youtubeLink!);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'This link can not be reached')));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    'Video',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.ondemand_video_rounded,
                                    color: Colors.red.shade300,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(
                              height: 15,
                            ),
                      const Text(
                        'Agent',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Name: ${listing.agentName}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Contact: ${listing.contactNo}'),
                      const SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                )
              ]),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'tag1',
              onPressed: () async {
                Uri url = Uri.parse('tel:${listing.contactNo}');
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could\'t Contacted')));
                }
              },
              label: const Text('Call'),
              icon: const Icon(Icons.call),
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton.extended(
                onPressed: () async {
                  await launchUrl(Uri.parse(
                      "https://wa.me/${listing.contactNo}?text=Hello"));

                  var link = WhatsAppUnilink(
                    phoneNumber: listing.contactNo,
                    text:
                        "Hey! I'm inquiring about the listing ${listing.propertyId}",
                  );
                  await launch('$link');
                },
                label: const Text('Whatsapp'),
                icon: const Icon(
                  Icons.call,
                ))
          ],
        ),
      ),
    );
  }

  //a method to show images indicators
  List<Widget> indicators(int length, int currentIndex) {
    return List.generate(
        length,
        (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Colors.black54
                        : Colors.black12),
              ),
            ));
  }
}

class RemoveFavouriteDialouge extends StatelessWidget {
  RemoveFavouriteDialouge(
      {super.key,
      required this.favouriteBloc,
      required this.listing,
      required this.favouritFetchBloc,
      required this.favouriteCheckBloc});
  FavouriteBloc favouriteBloc;
  FavouritFetchBloc favouritFetchBloc;
  Listing listing;
  FavouriteCheckBloc favouriteCheckBloc;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Remove'),
      content: const Text('Remove it from saved?'),
      actions: [
        TextButton(onPressed: () {}, child: const Text('No')),
        TextButton(
            onPressed: () {
              favouriteBloc
                  .add(RemoveFavouriteEvent(propertyId: listing.propertyId));
              favouriteCheckBloc
                  .add(FavouriteCheckEvent(propertyId: listing.propertyId));
              favouritFetchBloc.add(FavouritUpdateEvent());
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Yes')),
      ],
    );
  }
}

class FavouriteDialouge extends StatelessWidget {
  FavouriteDialouge(
      {super.key,
      required this.favouriteBloc,
      required this.listing,
      required this.favouritFetchBloc,
      required this.favouriteCheckBloc});
  FavouriteBloc favouriteBloc;
  FavouritFetchBloc favouritFetchBloc;
  Listing listing;
  FavouriteCheckBloc favouriteCheckBloc;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: favouriteBloc,
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Save it'),
          content: const Text('Do you want to save it?'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  favouriteBloc.add(AddFavouriteEvent(listing: listing));
                  favouriteCheckBloc
                      .add(FavouriteCheckEvent(propertyId: listing.propertyId));
                  favouritFetchBloc.add(FavouritUpdateEvent());

                  Navigator.of(context).pop();
                },
                child: const Text('Yes'))
          ],
        );
      },
    );
  }
}

//details widget
class DetailsWidget extends StatelessWidget {
  DetailsWidget({super.key, required this.listing});
  Listing listing;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DetailsTextWidget(
                keyO: 'Listing ID:',
                value: listing.propertyId,
              ),
              DetailsTextWidget(
                keyO: 'Land size:',
                value: '${listing.landSize} sq ft',
              ),
              DetailsTextWidget(
                keyO: 'Built up:',
                value: '${listing.builtUp} sq ft',
              ),
              DetailsTextWidget(
                keyO: 'Property Type:',
                value: listing.propertyType,
              ),
              DetailsTextWidget(
                keyO: 'Tenure:',
                value: listing.tenureDuration,
              ),
              DetailsTextWidget(
                keyO: 'Address:',
                value: listing.address,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//details inner widget
class DetailsTextWidget extends StatelessWidget {
  DetailsTextWidget({super.key, required this.keyO, required this.value});
  @override
  String keyO;
  String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(keyO),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

//room widget
class RoomsWidget extends StatelessWidget {
  RoomsWidget({super.key, required this.icons, required this.text});
  IconData icons;
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[300],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icons,
                color: AppColor.primaryBlue,
              ),
              const SizedBox(width: 10),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}
