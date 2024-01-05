//import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:algerian_touristic_guide_app/screens/home/place_list.dart';
import 'package:algerian_touristic_guide_app/screens/home/profile_update.dart';
//import 'package:algerian_touristic_guide_app/screens/home/place_tile.dart';
import 'package:algerian_touristic_guide_app/services/auth.dart';
import 'package:algerian_touristic_guide_app/utilities/colors.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(80.0), // here you can set the desired height
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 2.0,
            flexibleSpace: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/images/deserts.jpeg"),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Hello",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  children: [
                                TextSpan(
                                  text: ",Diaa",
                                  style: TextStyle(
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
              TextButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
                onPressed: () async {
                  //loading = true;
                  await _auth.signOut();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(248, 180, 8, 8)),
                ),
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
        ],
      ),
      body: <Widget>[
        SingleChildScrollView(child: const PlaceList(isBookmarkedPage: false)),
        SingleChildScrollView(child: const PlaceList(isBookmarkedPage: true)),
        SingleChildScrollView(child: const ProfileUpdate()),
      ][currentPageIndex],
    );
  }
}
