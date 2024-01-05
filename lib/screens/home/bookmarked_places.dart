import 'package:algerian_touristic_guide_app/models/place_user.dart';
import 'package:algerian_touristic_guide_app/models/user.dart';
import 'package:algerian_touristic_guide_app/screens/home/place_detail.dart';
import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:algerian_touristic_guide_app/shared/constants.dart';
//import 'package:algerian_touristic_guide_app/shared/constants.dart';
import 'package:flutter/material.dart';
//import 'place_list.dart';
import 'package:provider/provider.dart';

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

    return Column(
      children: [
        const SizedBox(height: 20.0),

        Container(
          //width: 280.0,
          padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
          child: DropdownButtonFormField<String?>(
            value: selectedState ?? 'All',
            decoration: textInputDecoration,
            hint: const Text("Select a wilaya"),
            onChanged: (val) => setState(() {
              selectedState = val;
            }),
            items: [
              const DropdownMenuItem(
                value: 'All',
                child: Text('All'),
              ),
              ...states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state ?? ''),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        // Category Filters
        Row(
          children: [
            const SizedBox(width: 16.0),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[300],
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  title: const Text(
                    "Museums",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedTileColor: Colors.green[300],
                  selected: isFilterMuseum,
                  onTap: () => setState(() {
                    if (!isFilterMuseum) {
                      selectedCategories.add("museum");
                      isFilterMuseum = true;
                      //print("$selectedCategories | $isFilterMuseum");
                    } else {
                      selectedCategories.remove("museum");
                      isFilterMuseum = false;
                      //print("$selectedCategories | $isFilterMuseum");
                    }
                  }),
                ),
              ),
            ),
            //const SizedBox(width: 10.0),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[300],
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  title: const Text(
                    "Food and Coffee",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedTileColor: Colors.green[300],
                  selected: isFilterRestAndCafe,
                  onTap: () => setState(() {
                    if (!isFilterRestAndCafe) {
                      selectedCategories.add("restaurant_coffee");
                      isFilterRestAndCafe = true;
                      //print("$selectedCategories | $isFilterMuseum");
                    } else {
                      selectedCategories.remove("restaurant_coffee");
                      isFilterRestAndCafe = false;
                      //print("$selectedCategories | $isFilterMuseum");
                    }
                  }),
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[300],
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  title: const Text(
                    "Historical Places",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedTileColor: Colors.green[300],
                  selected: isFilterHistoricalPlaces,
                  onTap: () => setState(() {
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
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[300],
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  title: const Text(
                    "Other Places",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedTileColor: Colors.green[300],
                  selected: isFilterOthers,
                  onTap: () => setState(() {
                    if (!isFilterOthers) {
                      selectedCategories.add("others");
                      isFilterOthers = true;
                      //print("$selectedCategories | $isFilterMuseum");
                    } else {
                      selectedCategories.remove("others");
                      isFilterOthers = false;
                      //print("$selectedCategories | $isFilterMuseum");
                    }
                  }),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
          ],
        ),

        Expanded(
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
              : ListView.builder(
                  itemCount: bookmarkedPlaces.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                                bookmarkedPlaces[index].imagePath ?? ''),
                          ),
                          title: Text(
                            bookmarkedPlaces[index].name ?? '',
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 14.0), // Adjusting the icon
                              const SizedBox(
                                  width:
                                      4.0), // Space between the icon and text
                              Expanded(
                                  child: Text(
                                      bookmarkedPlaces[index].location ??
                                          '')), // Location text
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaceDetail(
                                      place: bookmarkedPlaces[index])),
                            );
                          },
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
