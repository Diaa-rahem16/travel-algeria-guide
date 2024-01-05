import 'package:algerian_touristic_guide_app/models/place_user.dart';
import 'package:algerian_touristic_guide_app/models/user.dart';
import 'package:algerian_touristic_guide_app/screens/home/review_section.dart';
import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:algerian_touristic_guide_app/services/database.dart';
//import 'package:algerian_touristic_guide_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceDetail extends StatefulWidget {
  final Place place;

  const PlaceDetail({Key? key, required this.place}) : super(key: key);

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  bool isBookmarked = false;
  bool isLiked = false;
  String likes = "0";

  void _showReviewPanel(place) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            color: Colors.grey[200],
            child: ReviewSection(place: place),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    likes = widget.place.likes.toString(); // Initialize likes here
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    String placeUserID = "${user!.uid}-${widget.place.placeID}";
    //String likes = widget.place.likes.toString();

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(widget.place.name ?? "Algeria Tour"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[400],
        elevation: 0.0,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
          //color: Colors.grey[100],
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 250.0,
                  width: 700.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(48),
                        child: Image.asset(
                          widget.place.imagePath!,
                          fit: BoxFit.cover,
                          height: 300.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    widget.place.name!,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14.0, color: Colors.grey[700]),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          widget.place.location!,
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text(
                            "Description:",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 0.0, 22.0, 0.0),
                          child: Text(
                            widget.place.description!,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          const SizedBox(width: 25.0),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color?>(
                                        Colors.green[400]),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(150.0, 40.0)),
                              ),
                              child: const Text(
                                'REVIEWS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () {
                                return _showReviewPanel(widget.place);
                              },
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: StreamBuilder<PlaceUser>(
                                  stream:
                                      DatabaseService().placeUser(placeUserID),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      isLiked = snapshot.data!.isLiked ?? false;
                                      isBookmarked =
                                          snapshot.data!.isBookmarked ?? false;
                                    }
                                    return IconButton(
                                      isSelected: isBookmarked,
                                      icon: const Icon(Icons.bookmark_outline),
                                      selectedIcon: const Icon(Icons.bookmark),
                                      color: Colors.green[400],
                                      onPressed: () {
                                        setState(() {
                                          if (isBookmarked) {
                                            isBookmarked = false;
                                          } else {
                                            isBookmarked = true;
                                          }
                                        });
                                        DatabaseService().updatePlaceUser(
                                            placeUserID, isBookmarked, isLiked);
                                      },
                                    );
                                  })),
                          StreamBuilder<PlaceUser>(
                              stream: DatabaseService().placeUser(placeUserID),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  isLiked = snapshot.data!.isLiked ?? false;
                                  isBookmarked =
                                      snapshot.data!.isBookmarked ?? false;
                                  //likes = widget.place.likes.toString();
                                }
                                return IconButton(
                                  isSelected: isLiked,
                                  icon: const Icon(Icons.favorite_outline),
                                  selectedIcon: const Icon(Icons.favorite),
                                  color: Colors.green[400],
                                  onPressed: () {
                                    if (isLiked) {
                                      //await DatabaseService().updatePlaceLike(widget.place.placeID, false);

                                      setState(() {
                                        isLiked = false;
                                        likes = (int.parse(likes) - 1)
                                            .toString(); // Decrement like count
                                      });
                                      DatabaseService().updatePlaceLike(
                                          widget.place.placeID, false);
                                    } else {
                                      //await DatabaseService().updatePlaceLike(widget.place.placeID, true);

                                      setState(() {
                                        isLiked = true;
                                        likes = (int.parse(likes) + 1)
                                            .toString(); // Increment like count
                                      });
                                      DatabaseService().updatePlaceLike(
                                          widget.place.placeID, true);
                                    }
                                    DatabaseService().updatePlaceUser(
                                        placeUserID, isBookmarked, isLiked);
                                  },
                                );
                              }),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              likes,
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.green[400]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
