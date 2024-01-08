import 'package:algerian_touristic_guide_app/models/place_user.dart';
import 'package:algerian_touristic_guide_app/models/user.dart';
import 'package:algerian_touristic_guide_app/screens/home/place_detail.dart';
import 'package:algerian_touristic_guide_app/screens/home/widgets/category_card.dart';
import 'package:algerian_touristic_guide_app/screens/home/widgets/recomanded_card.dart';
import 'package:algerian_touristic_guide_app/utilities/colors.dart';
//import 'package:algerian_touristic_guide_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
//import 'place_list.dart';
import 'package:provider/provider.dart';
import 'package:algerian_touristic_guide_app/models/place.dart';

class BookmarkedPlaces extends StatefulWidget {
  const BookmarkedPlaces({super.key});

  @override
  State<BookmarkedPlaces> createState() => _ListTileState();
}

class _ListTileState extends State<BookmarkedPlaces> {
  String? selectedState = 'All';
  List<String?> selectedCategories = [];

  bool isFilterMuseum = false;
  bool isFilterRestAndCafe = false;
  bool isFilterHistoricalPlaces = false;
  bool isFilterOthers = false;

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>?>(context) ?? [];
    final user = Provider.of<AppUser?>(context);
    final userPlaces = Provider.of<List<PlaceUser>?>(context);

    List<Place> bookmarkedPlaces = places.where((place) {
      // Ensure user is not null before proceeding
      if (user == null) {
        return false;
      }
      // Ensure the userPlaces is not null or empty before proceeding
      if (userPlaces == null || userPlaces.isEmpty) {
        return false;
      }

      String placeUserID1 = "${user.uid}-${place.placeID}";

      for (var userPlace in userPlaces) {
        String placeUserID2 = userPlace.placeUserID;
        if (placeUserID1 == placeUserID2 && userPlace.isBookmarked!) {
          return true; // Match found and it's bookmarked
        }
      }

      return false; // No match found after checking all userPlaces
    }).toList();

    List<String?> states = places
        .map((place) {
          return place.state;
        })
        .toSet()
        .toList();

    bookmarkedPlaces = bookmarkedPlaces.where((bookmarkedPlace) {
      // Filter by state
      if (selectedState != 'All' && bookmarkedPlace.state != selectedState) {
        return false;
      }

      // Filter by categories
      if (selectedCategories.isNotEmpty &&
          !selectedCategories.contains(bookmarkedPlace.category)) {
        return false;
      }

      return true;
    }).toList();

    return SafeArea(
      child: Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          color: kBgClr,
          child: Column(
            children: [
              const SizedBox(height: 20.0),

              Material(
                borderRadius: BorderRadius.circular(50),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: SearchableDropdown.single(
                        items: states.map((state) {
                          return DropdownMenuItem(
                            value: state,
                            child: Text(state ?? ''),
                          );
                        }).toList(),
                        value: selectedState,
                        hint: "Select a wilaya",
                        searchHint: "Select a wilaya",
                        onChanged: (value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                        isExpanded: true,
                        closeButton: "Close",
                        onClear: () {
                          setState(() {
                            selectedState = "All";
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              // Category Filters
              Row(
                children: [
                  Container(
                    child: Text("Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26)),
                  ),
                ],
              ),
              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        CategoryCard(
                            isClicked: isFilterMuseum,
                            press: () => setState(() {
                                  if (!isFilterMuseum) {
                                    selectedCategories.add("museum");
                                    isFilterMuseum = true;
                                  } else {
                                    if (selectedCategories.contains("museum")) {
                                      selectedCategories.remove("museum");
                                    }
                                    isFilterMuseum = false;
                                  }
                                }),
                            title: "Mueseum",
                            image: "assets/constantine/ConM1.jpg"),
                        CategoryCard(
                            isClicked: isFilterRestAndCafe,
                            press: () => setState(() {
                                  if (!isFilterRestAndCafe) {
                                    selectedCategories.add("restaurant_coffee");
                                    isFilterRestAndCafe = true;
                                    //print("$selectedCategories | $isFilterMuseum");
                                  } else {
                                    selectedCategories
                                        .remove("restaurant_coffee");
                                    isFilterRestAndCafe = false;
                                    //print("$selectedCategories | $isFilterMuseum");
                                  }
                                }),
                            title: "restaurant coffee",
                            image: "assets/constantine/ConH1.jpg"),
                        CategoryCard(
                            isClicked: isFilterHistoricalPlaces,
                            press: () => setState(() {
                                  if (!isFilterHistoricalPlaces) {
                                    selectedCategories.add("historical_place");
                                    isFilterHistoricalPlaces = true;
                                    //print("$selectedCategories | $isFilterMuseum");
                                  } else {
                                    selectedCategories
                                        .remove("historical_place");
                                    isFilterHistoricalPlaces = false;
                                    //print("$selectedCategories | $isFilterMuseum");
                                  }
                                }),
                            title: "historical place",
                            image: "assets/constantine/ConR1.jpg"),
                        CategoryCard(
                            isClicked: isFilterOthers,
                            title: "Other placses",
                            image: "image",
                            press: () => setState(() {
                                  if (!isFilterOthers) {
                                    selectedCategories.add("others");
                                    isFilterOthers = true;
                                    //print("$selectedCategories | $isFilterMuseum");
                                  } else {
                                    selectedCategories.remove("others");
                                    isFilterOthers = false;
                                    //print("$selectedCategories | $isFilterMuseum");
                                  }
                                }))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),

              Container(
                child: bookmarkedPlaces.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No places were bookmarked yet.",
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Text("Bookmarked places",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26))
                            ],
                          ),
                          Container(
                              height: 280,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.only(left: 15),
                              child: ListView.builder(
                                  itemCount: bookmarkedPlaces.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: (Row(
                                        children: [
                                          RecomandedCard(
                                            image: bookmarkedPlaces[index]
                                                    .imagePath ??
                                                '',
                                            name:
                                                bookmarkedPlaces[index].name ??
                                                    '',
                                            state:
                                                bookmarkedPlaces[index].state ??
                                                    '',
                                            press: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlaceDetail(
                                                            place:
                                                                bookmarkedPlaces[
                                                                    index])),
                                              );
                                            },
                                          ),
                                        ],
                                      )),
                                    );
                                  })),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
