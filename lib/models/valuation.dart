// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Valuation {
  String name;
  String mobileNo;
  String? email;
  String? propertyAddress;
  String? postalCode;
  String? lastRenovation;
  String? landSize;
  String? builtUp;
  String? renovationCost;
  String? expectedPrice;
  Valuation({
    required this.name,
    required this.mobileNo,
    this.email,
    this.propertyAddress,
    this.postalCode,
    this.lastRenovation,
    this.landSize,
    this.builtUp,
    this.renovationCost,
    this.expectedPrice,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobileNo': mobileNo,
      'email': email,
      'propertyAddress': propertyAddress,
      'postalCode': postalCode,
      'lastRenovation': lastRenovation,
      'landSize': landSize,
      'builtUp': builtUp,
      'renovationCost': renovationCost,
      'expectedPrice': expectedPrice,
    };
  }

   factory Valuation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Valuation(
     name: data?['name'],
     mobileNo: data?['mobileNo'],
     email: data?['email'],
     propertyAddress: data?['propertyAddress'],
     postalCode: data?['postalCode'],
     lastRenovation: data?['lastRenovation'],
     landSize: data?['landSize'],
     builtUp: data?['builtUp'],
     renovationCost: data?['renovationCost'],
     expectedPrice: data?['expectedPrice'],
    );
  }
  factory Valuation.fromMap(Map<String, dynamic> map) {
    return Valuation(
      name: map['name'] as String,
      mobileNo: map['mobileNo'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      propertyAddress: map['propertyAddress'] != null ? map['propertyAddress'] as String : null,
      postalCode: map['postalCode'] != null ? map['postalCode'] as String : null,
      lastRenovation: map['lastRenovation'] != null ? map['lastRenovation'] as String : null,
      landSize: map['landSize'] != null ? map['landSize'] as String : null,
      builtUp: map['builtUp'] != null ? map['builtUp'] as String : null,
      renovationCost: map['renovationCost'] != null ? map['renovationCost'] as String : null,
      expectedPrice: map['expectedPrice'] != null ? map['expectedPrice'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Valuation.fromJson(String source) => Valuation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Valuation(name: $name, mobileNo: $mobileNo, email: $email, propertyAddress: $propertyAddress, postalCode: $postalCode, lastRenovation: $lastRenovation, landSize: $landSize, builtUp: $builtUp, renovationCost: $renovationCost, expectedPrice: $expectedPrice)';
  }

  @override
  bool operator ==(covariant Valuation other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.mobileNo == mobileNo &&
      other.email == email &&
      other.propertyAddress == propertyAddress &&
      other.postalCode == postalCode &&
      other.lastRenovation == lastRenovation &&
      other.landSize == landSize &&
      other.builtUp == builtUp &&
      other.renovationCost == renovationCost &&
      other.expectedPrice == expectedPrice;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      mobileNo.hashCode ^
      email.hashCode ^
      propertyAddress.hashCode ^
      postalCode.hashCode ^
      lastRenovation.hashCode ^
      landSize.hashCode ^
      builtUp.hashCode ^
      renovationCost.hashCode ^
      expectedPrice.hashCode;
  }
}
