// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Banker {
  String name;
  String mobileNo;
  String? email;
  String? preferedBank;
  Banker({
    required this.name,
    required this.mobileNo,
    this.email,
    this.preferedBank,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mobileNo': mobileNo,
      'emailAddress': email,
      'preferedBank': preferedBank,
    };
  }

  factory Banker.fromMap(Map<String, dynamic> map) {
    return Banker(
      name: map['name'] as String,
      mobileNo: map['mobileNo'] as String,
      email:
          map['emailAddress'] != null ? map['emailAddress'] as String : null,
      preferedBank:
          map['preferedBank'] != null ? map['preferedBank'] as String : null,
    );
  }
  factory Banker.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Banker(
      name: data?['name'],
      mobileNo: data?['mobileNo'],
      email: data?['email'],
    );
  }
}
