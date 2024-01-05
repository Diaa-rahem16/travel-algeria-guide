import 'package:algerian_touristic_guide_app/models/review.dart';
import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:algerian_touristic_guide_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:algerian_touristic_guide_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:algerian_touristic_guide_app/models/user.dart';
import "package:intl/intl.dart";

class ReviewSection extends StatefulWidget {
  final Place place;
  const ReviewSection({super.key, required this.place});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final _formKey = GlobalKey<FormState>();

  String? reviewText;
  String? error = "";
  final TextEditingController _reviewController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);

    String reviewID = "${user.uid}-${widget.place.placeID}";
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<Review>>(
            stream: DatabaseService().getReviewsForPlace(widget.place.placeID),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return SizedBox(
                  height: 250.0,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      snapshot.data!.sort((a, b) => DateFormat(
                              'dd-MM-yyyy hh:mm')
                          .parse(b.date!)
                          .compareTo(
                              DateFormat('dd-MM-yyyy hh:mm').parse(a.date!)));
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  snapshot.data![index].username ?? "",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color:
                                        user.uid == snapshot.data![index].userID
                                            ? Colors.red[400]
                                            : Colors.green[400],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Text(
                                  snapshot.data![index].date ?? "",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              snapshot.data![index].content ?? "",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(); // Return an empty container when there are no reviews
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.green[400],
              thickness: 3.0,
            ),
          ),
          StreamBuilder<Review>(
              stream: DatabaseService().userReview(reviewID),
              builder: (context, snapshot2) {
                if (snapshot2.hasData && snapshot2.data != null) {
                  if (!_isEditing) {
                    _reviewController.text = snapshot2.data!.content ?? "";
                    reviewText = snapshot2.data!.content ?? "";
                  }
                }
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: null,
                        controller: _reviewController,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Add a Review'),
                        validator: (val) => val!.trim().isEmpty
                            ? 'This field cannot be left empty.'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            reviewText = val;
                            _isEditing = true;
                          });
                        },
                        onFieldSubmitted: (val) {
                          _isEditing = false;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color?>(
                                      Colors.green[400]),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(150.0, 40.0)),
                            ),
                            child: const Text(
                              'PUBLISH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                DatabaseService().updateReview(
                                    reviewID,
                                    user.fullName,
                                    reviewText,
                                    DateFormat('dd-MM-yyyy hh:mm')
                                        .format(DateTime.now())
                                        .toString(),
                                    widget.place.placeID,
                                    user.uid);
                                error = "";
                              }
                            },
                          ),
                          const SizedBox(width: 20.0),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color?>(
                                      Colors.red[400]),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(150.0, 40.0)),
                            ),
                            child: const Text(
                              'DELETE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () async {
                              error = await DatabaseService()
                                  .deleteReview(reviewID);
                              try {
                                setState(() {
                                  error = error;
                                  if (error == "") {
                                    _reviewController.text = "";
                                    reviewText = "";
                                    error =
                                        "Your review has been successfully deleted";
                                  }
                                });
                              } catch (e) {
                                error = "";
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        error ?? "",
                        style: TextStyle(
                          color: error ==
                                  "Your review has been successfully deleted"
                              ? Colors.green[700]
                              : const Color.fromARGB(248, 180, 8, 8),
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
