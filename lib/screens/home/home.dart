//import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:algerian_touristic_guide_app/models/user.dart';
import 'package:algerian_touristic_guide_app/screens/home/place_list.dart';
import 'package:algerian_touristic_guide_app/screens/home/profile_update.dart';
import 'package:algerian_touristic_guide_app/screens/home/widgets/FormPlace.dart';
//import 'package:algerian_touristic_guide_app/screens/home/place_tile.dart';
import 'package:algerian_touristic_guide_app/services/auth.dart';
import 'package:algerian_touristic_guide_app/utilities/colors.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

final _formKeyName = GlobalKey<FormState>();
String? fullName;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

@override
class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int currentPageIndex = 0;
  //bool loading = false;
  @override
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              80.0), // here you can set the desired height
          child: AppBar(
            backgroundColor: kPrimearyClr,
            elevation: 2.0,
            flexibleSpace: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D"),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Hello",
                                  style: TextStyle(
                                      color: Colors.grey[200], fontSize: 18),
                                  children: [
                                TextSpan(
                                  text: ", " " ${user!.fullName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out'),
                    onPressed: () async {
                      //loading = true;
                      await _auth.signOut();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(kBgClr),
                    ),
                  ),
                ],
              ),
            ],
          )),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: kPrimearyClr,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmarked',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'profile',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add),
            icon: Icon(Icons.add),
            label: 'add place',
          ),
        ],
      ),
      body: <Widget>[
        SingleChildScrollView(child: const PlaceList(isBookmarkedPage: false)),
        SingleChildScrollView(child: const PlaceList(isBookmarkedPage: true)),
        SingleChildScrollView(child: const ProfileUpdate()),
        SingleChildScrollView(child: FormPlace()),
      ][currentPageIndex],
    );
  }
}
