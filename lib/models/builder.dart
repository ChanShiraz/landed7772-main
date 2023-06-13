// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BuilderModel {
  String name;
  String mobileNo;
  String? email;
  String? propertyAddress;
  String? postalCode;
  BuilderModel({
    required this.name,
    required this.mobileNo,
    this.email,
    this.propertyAddress,
    this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobileNo': mobileNo,
      'email': email,
      'propertyAddress': propertyAddress,
      'postalCode': postalCode,
    };
  }

  factory BuilderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return BuilderModel(
        name: data?['name'],
        mobileNo: data?['mobileNo'],
        email: data?['email'],
        propertyAddress: data?['propertyAddress'],
        postalCode: data?['postalCode']);
  }

  String toJson() => json.encode(toMap());
}
