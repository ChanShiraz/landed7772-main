import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/screens/home.dart';
import 'package:layout/screens/login.dart';
import 'package:layout/state/bloc/indicator_bloc.dart';
import 'package:layout/state/favourite_bloc/favourite_bloc.dart';
import 'package:layout/state/favourite_check/bloc/favourite_check_bloc.dart';
import 'package:layout/state/favourite_fetch/bloc/favourit_fetch_bloc.dart';
import 'package:layout/state/keyboard_bloc/keyboard_bloc.dart';
import 'package:layout/state/listing_bloc/listing_bloc.dart';
import 'package:layout/state/markers/bloc/markers_bloc_bloc.dart';
import 'package:layout/state/navbar_bloc/navbar_bloc.dart';
import 'package:layout/state/open_house/bloc/open_house_bloc.dart';
import 'package:layout/state/searching_bloc/bloc/searching_bloc.dart';
import 'package:layout/state/text_box/bloc/text_box_bloc.dart';
import 'package:layout/utils/notification_services.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationServices notificationServices = NotificationServices();
  notificationServices.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => TextBoxBloc(),
      ),
      BlocProvider(
        create: (context) => NavbarBloc(),
      ),
      BlocProvider(
        create: (context) => ListingBloc(),
      ),
      BlocProvider(
        create: (context) => IndicatorBloc(),
      ),
      BlocProvider(
        create: (context) => FavouriteBloc(),
      ),
      BlocProvider(
        create: (context) => FavouritFetchBloc(),
      ),
      BlocProvider(
        create: (context) => FavouriteCheckBloc(),
      ),
      BlocProvider(
        create: (context) => SearchingBloc(),
      ),
      BlocProvider(
        create: (context) => OpenHouseBloc(),
      ),
      BlocProvider(
        create: (context) => MarkersBloc(),
      ),
       BlocProvider(
        create: (context) => KeyboardBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    NotificationServices notificationServices = NotificationServices();
    notificationServices.notificationInit();
    notificationServices.foregroundMessage();
    //notificationServices.sendTopicNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:
          //ValuationForm()
          StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const  CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data != null) {
            return HomeScreen();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
