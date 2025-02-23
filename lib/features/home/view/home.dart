import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/costants/colors.dart';
import 'package:layout/screens/drawer_page/about.dart';
import 'package:layout/screens/drawer_page/bankder.dart';
import 'package:layout/screens/drawer_page/builder.dart';
import 'package:layout/screens/drawer_page/property.dart';
import 'package:layout/screens/drawer_page/valuation%20.dart';
import 'package:layout/features/home/view/home_page.dart';
import 'package:layout/features/open_house/view/open_house.dart';
import 'package:layout/screens/nav_pages/save_page.dart';
import 'package:layout/screens/nav_pages/searh_page.dart';
import 'package:layout/state/navbar_bloc/navbar_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  int selectedIndex = 0;
  late NavbarBloc navbarBloc;
  final List<Widget> pages = [
    HomePage(),
    SearchPage(),
    SavedPage(),
    const OpenHousePage()
  ];
  String? name;
  //User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    // final ref = FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(user.uid)
    //     .get()
    //     .then((value) {
    //   if (value.data() != null) {
    //     name = value.data()!['Name'];
    //     print(name);
    //   }
    //   return;
    // });
    navbarBloc = context.read<NavbarBloc>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Landed7772',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: BlocBuilder(
          bloc: navbarBloc,
          builder: (context, state) {
            //return pages.elementAt(state as int);
            return IndexedStack(
              index: state as int,
              children: pages,
            );
          },
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            // DrawerHeader(
            //   decoration: BoxDecoration(color: Colors.grey.shade300),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const CircleAvatar(
            //           radius: 35,
            //           child: Icon(
            //             Icons.person_outline,
            //             size: 50,
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         FutureBuilder(
            //           future: FirebaseFirestore.instance
            //               .collection('Users')
            //               .doc(user.uid)
            //               .get()
            //               .then((value) => value.data()!['Name']),
            //           builder: (context, snapshot) {
            //             if (snapshot.hasData && snapshot.data != null) {
            //               return Text(
            //                 snapshot.data!,
            //                 style: const TextStyle(
            //                     fontSize: 20, fontWeight: FontWeight.bold),
            //               );
            //             }
            //             return Container();
            //           },
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         Text(user.email != null ? user.email! : '')
            //       ],
            //     ),
            //   ),
            // ),
            ListTile(
                onTap: () => visitLink(
                    'https://www.youtube.com/playlist?list=PLbnBlzHq1pxa27MGbGzSzBFpLpgqRI8Io',
                    context),
                leading: const Icon(Icons.ondemand_video),
                title: const Text('Landed Property Videos')),
            ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ValuationForm(
                        formName: 'Valuation Form',
                        description:
                            'Determine the true value of your property with ease. Simply fill out this comprehensive form, providing all necessary details, and we will get back to you as soon as possible with an accurate assessment of your property\'s worth.',
                      ),
                    )),
                leading: const Icon(Icons.local_atm_outlined),
                title: const Text('Request For Valuation')),
            ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PropertyRequest(),
              )),
              title: const Text('Request For Property'),
              leading: const Icon(Icons.business_center_outlined),
            ),
            ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequestForBuilderScreen(
                        formType: 'Builder',
                        description:
                            'Planning a rebuild or reconstruction for your landed property? We partner with skilled builders we trust. Fill out the form, and we\'ll promptly connect you with the ideal expert.',
                      ),
                    )),
                leading: const Icon(Icons.construction_outlined),
                title: const Text('Request For Builder')),
            ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequestForBankerScreen(),
                    )),
                leading: const Icon(Icons.person_pin_outlined),
                title: const Text('Request For Banker')),
            ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequestForBuilderScreen(
                        formType: 'Legal Advice',
                        description:
                            'Seeking legal guidance for a property concern? Complete the form, and we\'ll promptly connect you with our experienced legal advisor.',
                      ),
                    )),
                leading: const Icon(Icons.local_police_outlined),
                title: const Text('Request For Legal Advice')),
            ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ValuationForm(
                        formName: '1-1 Consultation',
                        description:
                            'Looking for property advice? Fill out the form, and we\'ll arrange a free one-on-one consultation tailored to your needs.',
                      ),
                    )),
                leading: const Icon(Icons.person_add_alt),
                title: const Text('Request for 1-1 consultation')),
            ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ValuationForm(
                        formName: 'List your property with us',
                        description: '',
                      ),
                    )),
                leading: const Icon(Icons.connect_without_contact_outlined),
                title: const Text('List Property With Us')),
            ListTile(
                onTap: () => visitLink(
                    'https://www.orangetee.com/newsroom/newsroompage.aspx?Cat=In%20The%20News',
                    context),
                leading: const Icon(Icons.newspaper),
                title: const Text('In The News')),
            ListTile(
                onTap: () =>
                    visitLink('https://www.facebook.com/LDA7772/', context),
                leading: const Icon(Icons.facebook),
                title: const Text('Our Facebook')),
            ListTile(
                onTap: () => visitLink('https://landed7772.com', context),
                leading: const Icon(Icons.web),
                title: const Text('Our Website')),
            ListTile(
                onTap: () => visitLink(
                    'https://www.youtube.com/playlist?list=PLCftdv0B_Jui-Knbw7L2ySi37SpQL5oal',
                    context),
                leading: const Icon(Icons.business_rounded),
                title: const Text('Market Pulse')),
            ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutUsPage(),
                    )),
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('About us')),
            // ListTile(
            //   onTap: () async {
            //     showDialog(
            //         context: context,
            //         builder: (context) => const LoadingDialouge());
            //     try {
            //       await FirebaseAuth.instance.currentUser?.delete();
            //       print('account done');
            //       //await FirebaseAuth.instance.signOut();
            //       ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(content: Text('Account Deleted!')));
            //       Navigator.pushAndRemoveUntil<dynamic>(
            //         context,
            //         MaterialPageRoute<dynamic>(
            //           builder: (BuildContext context) => LoginPage(),
            //         ),
            //         (route) =>
            //             false, //if you want to disable back feature set to false
            //       );
            //     } catch (e) {
            //       ScaffoldMessenger.of(context)
            //           .showSnackBar(SnackBar(content: Text(e.toString())));
            //     }
            //     // showDialog(
            //     //   context: context,
            //     //   builder: (context) => const DeleteAccoutnDialouge(),
            //     // );
            //   },
            //   leading: const Icon(Icons.delete_forever_outlined),
            //   title: const Text('Delete my account'),
            // ),
            // ListTile(
            //     onTap: () async {
            //       showDialog(
            //         context: context,
            //         builder: (context) => const LogOutDialouge(),
            //       );
            //     },
            //     leading: const Icon(Icons.logout),
            //     title: const Text('Logout')),
          ],
        )),
        bottomNavigationBar: BlocBuilder(
          bloc: navbarBloc,
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state as int,
              onTap: (value) => navbarBloc.add(NavBarTapEvent(index: value)),
              type: BottomNavigationBarType.fixed,
              unselectedIconTheme: const IconThemeData(color: Colors.black38),
              selectedIconTheme:
                  const IconThemeData(color: AppColor.primaryBlue, size: 30),
              selectedItemColor: AppColor.primaryBlue,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_outline_outlined),
                    label: 'Saved'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_work_outlined), label: 'Open House'),
              ],
            );
          },
        ),
      ),
    );
  }

  void visitLink(String getUrl, BuildContext context) async {
    Uri url = Uri.parse(getUrl);
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('The link is broken!')));
    }
  }
}

class DeleteAccoutnDialouge extends StatelessWidget {
  const DeleteAccoutnDialouge({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Account'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: const Text('Do you really want to delete your account?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No')),
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => const LoadingDialouge(),
              );
              try {
                await FirebaseAuth.instance.currentUser?.delete();
                print('Account deleted');
                await FirebaseAuth.instance.signOut();
              } catch (e) {
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text('yes'))
      ],
    );
  }
}

class LoadingDialouge extends StatelessWidget {
  const LoadingDialouge({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deleting Account'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Please wait! we are deleting your account.'),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}

class LogOutDialouge extends StatelessWidget {
  const LogOutDialouge({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: const Text('Do you want to logout?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No')),
        TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pop();
              });
            },
            child: const Text('yes'))
      ],
    );
  }
}
