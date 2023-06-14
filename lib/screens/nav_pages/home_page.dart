import 'package:badges/badges.dart' as badge;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:layout/costants/colors.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/models/listing.dart';
import 'package:layout/screens/listing_details.dart';
import 'package:layout/screens/nav_pages/starbuy_all.dart';
import 'package:layout/state/listing_bloc/listing_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../state/open_house/bloc/open_house_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  late ListingBloc listingBloc;
  late OpenHouseBloc openHouseBloc;
  @override
  Widget build(BuildContext context) {
    listingBloc = context.read<ListingBloc>();
    openHouseBloc = context.read<OpenHouseBloc>();
    listingBloc.add(FetchListingEvent());
    return SizedBox(
        height: context.height,
        child: BlocBuilder(
          bloc: listingBloc,
          builder: (context, state) {
            if (state is ListingLoadingState) {
              return const ListingLoadingWidget();
            } else if (state is ListingLoadedState) {
              openHouseBloc
                  .add(OpenHouseFetchEvent(mapListings: state.listings));
              return ListingLoadedWidget(
                list: state.listings,
                starBuyList: state.starBuyListing,
              );
            }
            return const Center(
              child: Text('Some error occured'),
            );
          },
        ));
  }
}
//stack like effect in star buy

//loaded widget
class ListingLoadedWidget extends StatelessWidget {
  ListingLoadedWidget(
      {super.key, required this.list, required this.starBuyList});
  List<Listing> list;
  List<Listing> starBuyList;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              starBuyList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Starbuy Listings',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  StarBuyAllScreen(starBuyListing: starBuyList),
                            )),
                            child: const Text(
                              'See all >',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ))
                  : Container()
            ],
          ),
        ),
        SliverToBoxAdapter(
            child: starBuyList.isNotEmpty
                ? SizedBox(
                    height: context.height * 0.19,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: starBuyList.length,
                      itemBuilder: (context, index) {
                        return ListingWidget(
                          onClick: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ListingDetailsScreen(
                                    listing: starBuyList[index]);
                              },
                            ));
                          },
                          listing: starBuyList[index],
                          showBadge: true,
                          starBuy: Row(
                            children: [
                              Container(
                                height: 25,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                //width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[350],
                                    border: Border.all(
                                        color: AppColor.primaryBlue)),
                                child: const Center(
                                  child: Text(
                                    'Starbuy',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Container()),
        SliverList(
            delegate: SliverChildListDelegate([
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Latest Listings',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ),
        ])),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListingWidget(
              onClick: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return ListingDetailsScreen(listing: list[index]);
                  },
                ));
              },
              listing: list[index],
              showBadge: false,
            );
          }, childCount: list.length),
        ),
      ],
    );
  }
}

//loading widget
class ListingLoadingWidget extends StatelessWidget {
  const ListingLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Latest Listings',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
              ),
              const ShimmerLoading(),
              const ShimmerLoading(),
              const ShimmerLoading(),
              const ShimmerLoading(),
            ],
          ),
        )
      ],
    );
  }
}

//shimmer widget
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: Container(
                height: 152,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
        ),
      ),
    );
  }
}

//property listing widget
class ListingWidget extends StatelessWidget {
  ListingWidget(
      {super.key,
      required this.listing,
      this.starBuy,
      required this.showBadge,
      this.onClick});
  Listing listing;
  Widget? starBuy;
  VoidCallback? onClick;
  bool showBadge = false;
  @override
  Widget build(BuildContext context) {
    print(context.height*0.18);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: onClick,
        child: badge.Badge(
          showBadge: showBadge,
          badgeStyle: const badge.BadgeStyle(badgeColor: AppColor.primaryBlue),
          position: badge.BadgePosition.topStart(top: -5),
          badgeContent: const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 152,
              width: context.width - 20,
              decoration: starBuy == null
                  ? null
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColor.primaryBlue, width: 2)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: context.width * 0.33,
                        foregroundDecoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(listing.featuredImageUrl),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              starBuy == null ? Container() : starBuy!,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: 25,
                                //width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[350],
                                ),
                                child: Center(
                                  child: Text(
                                    'For ${listing.forSale}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 18,
                                color: AppColor.primaryBlue,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SingleChildScrollView(
                                child: Text(
                                  listing.address,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.bed_rounded,
                                size: 18,
                                color: AppColor.primaryBlue,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                listing.noOfBedRooms.toString(),
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.bathtub_outlined,
                                color: AppColor.primaryBlue,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                listing.noOfBathRooms.toString(),
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.area_chart_outlined,
                                color: AppColor.primaryBlue,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${listing.landSize} sq ft',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: context.width * 0.55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  listing.propertyType,
                                  style: const TextStyle(
                                      color: AppColor.primaryBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                                
                              ],
                            ),
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text(
                              
                                  '\$ ${NumberFormat("#,##0", "en_US").format(listing.price)}',
                                  overflow: TextOverflow.ellipsis,
                                )],)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
