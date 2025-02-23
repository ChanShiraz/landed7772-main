import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:layout/extensions/contexExt.dart';
import 'package:layout/features/home/controller/starbuy_controller.dart';
import 'package:layout/models/listing.dart';
import 'package:layout/screens/listing_details.dart';
import 'package:layout/features/home/view/home_page.dart';

import '../../costants/colors.dart';

class StarBuyAllScreen extends StatefulWidget {
  const StarBuyAllScreen({super.key});

  @override
  State<StarBuyAllScreen> createState() => _StarBuyAllScreenState();
}

class _StarBuyAllScreenState extends State<StarBuyAllScreen> {
  final StarBuyController starBuyController = Get.find<StarBuyController>();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        starBuyController.fetchMoreListings();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    starBuyController.getAllStarListings();
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
          Obx(() => starBuyController.isLoadingListing.value
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height * 0.4,
                      ),
                      const CircularProgressIndicator()
                    ],
                  ),
                )
              : Obx(() => Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: starBuyController.starListings.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListingDetailsScreen(
                              listing: starBuyController.starListings[index]),
                        )),
                        child: ListingWidget(
                          listing: starBuyController.starListings[index],
                          showBadge: true,
                          starBuy: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                height: 25,
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
                        ),
                      ),
                    ),
                  )))
        ],
      ),
    ));
  }
}
