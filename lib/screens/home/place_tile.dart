import 'package:algerian_touristic_guide_app/screens/home/place_detail.dart';
import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:algerian_touristic_guide_app/screens/home/widgets/category_card.dart';

import 'package:algerian_touristic_guide_app/shared/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'place_list.dart';
import 'package:provider/provider.dart';

import 'widgets/recomanded_card.dart';

class PlaceTile extends StatefulWidget {
  const PlaceTile({super.key});

  @override
  State<PlaceTile> createState() => _ListTileState();
}

class _ListTileState extends State<PlaceTile> {
  String? selectedState = 'All';
  List<String?> selectedCategories = [];

  bool isFilterMuseum = false;
  bool isFilterRestAndCafe = false;
  bool isFilterHistoricalPlaces = false;
  bool isFilterOthers = false;

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>?>(context) ?? [];

    List<String?> states = places
        .map((place) {
          return place.state;
        })
        .toSet()
        .toList();

    List<Place> filteredPlaces = places.where((place) {
      // Filter by state
      if (selectedState != 'All' && place.state != selectedState) {
        return false;
      }

      // Filter by categories
      if (selectedCategories.isNotEmpty &&
          !selectedCategories.contains(place.category)) {
        return false;
      }

      return true;
    }).toList();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20.0),

            //Dropdown menu of states
            Material(
              elevation: 5,
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
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("Category",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26))
              ],
            ),

            // Category Filters
            // start filter by category
            Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      CategoryCard(
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
                          press: () => setState(() {
                                if (!isFilterHistoricalPlaces) {
                                  selectedCategories.add("historical_place");
                                  isFilterHistoricalPlaces = true;
                                  //print("$selectedCategories | $isFilterMuseum");
                                } else {
                                  selectedCategories.remove("historical_place");
                                  isFilterHistoricalPlaces = false;
                                  //print("$selectedCategories | $isFilterMuseum");
                                }
                              }),
                          title: "historical place",
                          image: "assets/constantine/ConR1.jpg"),
                      CategoryCard(
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
            Row(
              children: [
                Text("Popular places",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26))
              ],
            ),

            Container(
                height: 280,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.only(left: 15),
                child: ListView.builder(
                    itemCount: filteredPlaces.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: (Row(
                          children: [
                            RecomandedCard(
                              image: filteredPlaces[index].imagePath ?? '',
                              name: filteredPlaces[index].name ?? '',
                              state: filteredPlaces[index].state ?? '',
                              press: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlaceDetail(
                                          place: filteredPlaces[index])),
                                );
                              },
                            ),
                          ],
                        )),
                      );
                    })),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
