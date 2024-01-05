import 'package:algerian_touristic_guide_app/models/place_user.dart';
import 'package:algerian_touristic_guide_app/screens/home/bookmarked_places.dart';
import 'package:algerian_touristic_guide_app/screens/home/place_tile.dart';
import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:algerian_touristic_guide_app/services/database.dart';
import 'package:provider/provider.dart';

class PlaceList extends StatefulWidget {
  final bool? isBookmarkedPage;
  const PlaceList({super.key, this.isBookmarkedPage});
  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  @override
  Widget build(BuildContext context) {
    //print(DatabaseService().place);
    Widget page;
    if (widget.isBookmarkedPage!) {
      page = StreamProvider<List<PlaceUser>>.value(
          value: DatabaseService().userPlace,
          initialData: const [],
          builder: (context, snapshot) {
            return const BookmarkedPlaces();
          });
    } else {
      page = const PlaceTile();
    }
    return StreamProvider<List<Place>>.value(
      value: DatabaseService().place,
      initialData: const [],
      child: page,
    );
  }
}
