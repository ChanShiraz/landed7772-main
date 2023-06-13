// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PropertyRequestModel {
  String name;
  String mobileNo;
  String? district;
  String? propertyType;
  String? tenure;
  PropertyRequestModel({
    required this.name,
    required this.mobileNo,
    this.district,
    this.propertyType,
    this.tenure,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobileNo': mobileNo,
      'district': district,
      'propertyType': propertyType,
      'tenure': tenure,
    };
  }

  factory PropertyRequestModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PropertyRequestModel(
        name: data?['name'],
        mobileNo: data?['mobileNo'],
        district: data?['district'],
        propertyType: data?['propertyType'],
        tenure: data?['tenure']);
  }
}
