import 'package:flutter/material.dart';
import 'package:layout/models/listing.dart';
import 'package:layout/screens/listing_details.dart';
import 'package:layout/screens/nav_pages/home_page.dart';

import '../../costants/colors.dart';

class StarBuyAllScreen extends StatelessWidget {
  const StarBuyAllScreen({super.key, required this.starBuyListing});
  final List<Listing> starBuyListing;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Starbuy Listings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: starBuyListing.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ListingDetailsScreen(listing: starBuyListing[index]),
                )),
                child: ListingWidget(
                  listing: starBuyListing[index],
                  showBadge: true,
                  starBuy: Row(
                    children: [
                      Container(
                        height: 25,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[350],
                            border: Border.all(color: AppColor.primaryBlue)),
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
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
