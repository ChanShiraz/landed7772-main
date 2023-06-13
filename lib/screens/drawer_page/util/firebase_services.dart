import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:layout/models/valuation.dart';

import '../../../models/banker.dart';
import '../../../models/builder.dart';
import '../../../models/property_request.dart';

class FirebaseServices {
  final ref = FirebaseFirestore.instance;
  void uploadValuatin(String formType, Valuation valuation) async {
    ref
        .collection('Requests')
        .doc(formType)
        .collection('collection')
        .withConverter(
          fromFirestore: Valuation.fromFirestore,
          toFirestore: (value, options) => value.toMap(),
        )
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(valuation);
  }

  void uploadBuilder(String formType, BuilderModel builder) {
    ref
        .collection('Requests')
        .doc(formType)
        .collection('collection')
        .withConverter(
          fromFirestore: BuilderModel.fromFirestore,
          toFirestore: (value, options) => value.toMap(),
        )
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(builder);
  }

  void uploadPropertyRequest(PropertyRequestModel model) {
    ref
        .collection('Requests')
        .doc('Property Request')
        .collection('collection')
        .withConverter(
          fromFirestore: PropertyRequestModel.fromFirestore,
          toFirestore: (value, options) => value.toMap(),
        )
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(model);
  }

  void uploadBankerRequest(Banker banker) {
    ref
        .collection('Requests')
        .doc('Banker Request')
        .collection('collection')
        .withConverter(
          fromFirestore: Banker.fromFirestore,
          toFirestore: (value, options) => value.toMap(),
        )
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(banker);
  }
}
