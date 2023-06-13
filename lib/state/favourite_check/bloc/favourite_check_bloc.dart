import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'favourite_check_event.dart';
part 'favourite_check_state.dart';

class FavouriteCheckBloc extends Bloc<FavouriteCheckEvents, FavouriteCheckState> {
  FavouriteCheckBloc() : super(FavouriteCheckInitial()) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    final uid = user.uid;
    final ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Favourites');
    on<FavouriteCheckEvents>((event, emit)async {
      if(event is FavouriteCheckEvent){
        await ref.doc(event.propertyId).get().then((snapShot) {
          if(snapShot.exists){
            emit(FavouriteCheckPresent());
          }
          else{
            emit(FavouriteCheckNull());
          }
        });
      }
    });
  }
}
