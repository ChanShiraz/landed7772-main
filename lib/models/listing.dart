import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Listing {
  String title;
  String propertyId;
  String address;
  String forSale;
  String? conditon;
  String? mapLocation;
  String featuredImageUrl;
  String? optionalImage1;
  String? optionalImage2;
  String? optionalImage3;

  int price;
  int landSize;
  int builtUp;
  String district;
  String propertyType;
  int noOfBedRooms;
  int noOfBathRooms;
  String tenureDuration;
  int starBuyListing;

  String description;
  String agentName;
  String contactNo;
  String? youtubeLink;
  int timeStamp;
  Listing(
      {required this.title,
      required this.address,
      required this.propertyId,
      required this.forSale,
      this.mapLocation,
      required this.featuredImageUrl,
      this.optionalImage1,
      this.optionalImage2,
      this.conditon,
      this.optionalImage3,
      required this.price,
      required this.landSize,
      required this.builtUp,
      required this.district,
      required this.propertyType,
      required this.noOfBedRooms,
      required this.noOfBathRooms,
      required this.tenureDuration,
      required this.starBuyListing,
      required this.description,
      required this.agentName,
      required this.contactNo,
      this.youtubeLink,
      required this.timeStamp});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'address': address,
      'mapLocation': mapLocation,
      'propertyId': propertyId,
      'forSale': forSale,
      'featuredImageUrl': featuredImageUrl,
      'optionalImage1': optionalImage1,
      'optionalImage2': optionalImage2,
      'optionalImage3': optionalImage3,
      'price': price,
      'conditon': conditon,
      'landSize': landSize,
      'builtUp': builtUp,
      'district': district,
      'propertyType': propertyType,
      'noOfBedRooms': noOfBedRooms,
      'noOfBathRooms': noOfBathRooms,
      'tenureDuration': tenureDuration,
      'starBuyListing': starBuyListing,
      'description': description,
      'agentName': agentName,
      'contactNo': contactNo,
      'youtubeLink': youtubeLink,
      'timeStamp': timeStamp
    };
  }

  factory Listing.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Listing(
      title: data?['title'],
      address: data?['address'],
      mapLocation: data?['mapLocation'],
      propertyId: data?['propertyId'],
      forSale: data?['forSale'],
      conditon: data?['conditon'],
      featuredImageUrl: data?['featuredImageUrl'],
      optionalImage1: data?['optionalImage1'],
      optionalImage2: data?['optionalImage2'],
      optionalImage3: data?['optionalImage3'],
      price: data?['price'],
      landSize: data?['landSize'],
      builtUp: data?['builtUp'],
      district: data?['district'],
      propertyType: data?['propertyType'],
      noOfBedRooms: data?['noOfBedRooms'],
      noOfBathRooms: data?['noOfBathRooms'],
      tenureDuration: data?['tenureDuration'],
      starBuyListing: data?['starBuyListing'],
      description: data?['description'],
      agentName: data?['agentName'],
      contactNo: data?['contactNo'],
      youtubeLink: data?['youtubeLink'],
      timeStamp: data?['timeStamp'],
    );
  }
  factory Listing.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    final data = map.data();
    return Listing(
      title: data?['title'] as String,
      address: data?['address'] as String,
      mapLocation: data?['mapLocation'] as String,
      propertyId: data?['propertyId'] as String,
      forSale: data?['forSale'] as String,
      featuredImageUrl: data?['featuredImageUrl'] as String,
      optionalImage1: data?['optionalImage1'] != null
          ? data!['optionalImage1'] as String
          : null,
      conditon: data?['conditon'] != null ? data!['conditon'] as String : null,
      optionalImage2: data?['optionalImage2'] != null
          ? data!['optionalImage2'] as String
          : null,
      optionalImage3: data?['optionalImage3'] != null
          ? data!['optionalImage3'] as String
          : null,
      price: data?['price'] as int,
      landSize: data?['landSize'] as int,
      builtUp: data?['builtUp'] as int,
      district: data?['district'] as String,
      propertyType: data?['propertyType'] as String,
      noOfBedRooms: data?['noOfBedRooms'] as int,
      noOfBathRooms: data?['noOfBathRooms'] as int,
      tenureDuration: data?['tenureDuration'] as String,
      starBuyListing: data?['starBuyListing'] as int,
      description: data?['description'] as String,
      agentName: data?['agentName'] as String,
      contactNo: data?['contactNo'] as String,
      youtubeLink:
          data?['youtubeLink'] != null ? data!['youtubeLink'] as String : null,
      timeStamp: data?['timeStamp'] as int,
    );
  }
}
