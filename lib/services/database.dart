import 'package:algerian_touristic_guide_app/models/review.dart';
import 'package:algerian_touristic_guide_app/models/place_user.dart';
import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //collection references
  final CollectionReference placeCollection =
      FirebaseFirestore.instance.collection('place');
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('review');
  final CollectionReference placeUserCollection =
      FirebaseFirestore.instance.collection('place_user');

  //update review Function
  Future<void> updateReview(String reviewID, String? username, String? content,
      String? date, String? placeID, String? userID) async {
    return await reviewCollection.doc(reviewID).set({
      'username': username,
      'content': content,
      'date': date,
      'placeID': placeID,
      'userID': userID,
    });
  }

  //delete a review:
  Future<String> deleteReview(String reviewID) async {
    DocumentSnapshot snapshot = await reviewCollection.doc(reviewID).get();
    if (snapshot.exists) {
      await reviewCollection.doc(reviewID).delete();
      return "";
    } else {
      return "You didn't add a review yet";
    }
  }

  // update the likes of a place:
  Future<void> updatePlaceLike(String placeID, bool operator) async {
    DocumentSnapshot snapshot = await placeCollection.doc(placeID).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    int likes = data['likes'] ?? 0;
    if (operator) {
      await placeCollection.doc(placeID).update({
        'likes': likes + 1,
      });
    } else {
      await placeCollection.doc(placeID).update({
        'likes': likes - 1,
      });
    }
  }

  // update placeUser collection
  Future<void> updatePlaceUser(
      String placeUserID, bool? isBookmarked, bool? isLiked) async {
    return await placeUserCollection.doc(placeUserID).set({
      'isBookmarked': isBookmarked,
      'isLiked': isLiked,
    });
  }

  // place list from snapshot
  List<Place> _placeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Place(
        placeID: doc.id,
        name: (doc.data() as Map<String, dynamic>)["name"],
        state: (doc.data() as Map<String, dynamic>)["state"],
        location: (doc.data() as Map<String, dynamic>)["location"],
        category: (doc.data() as Map<String, dynamic>)["category"],
        imagePath: (doc.data() as Map<String, dynamic>)["imagePath"],
        description: (doc.data() as Map<String, dynamic>)["description"],
        likes: (doc.data() as Map<String, dynamic>)["likes"],
      );
    }).toList();
  }

  // review list from snapshot
  List<Review> _reviewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Review(
        reviewID: doc.id,
        username: (doc.data() as Map<String, dynamic>)["username"],
        content: (doc.data() as Map<String, dynamic>)["content"],
        date: (doc.data() as Map<String, dynamic>)["date"],
        placeID: (doc.data() as Map<String, dynamic>)["placeID"],
        userID: (doc.data() as Map<String, dynamic>)["userID"],
      );
    }).toList();
  }

  // user review from snapshot:
  Review _userReviewFromSnapshot(DocumentSnapshot snapshot) {
    return Review(
      reviewID: snapshot.id,
      username: (snapshot.data() as Map<String, dynamic>)["username"],
      content: (snapshot.data() as Map<String, dynamic>)["content"],
      date: (snapshot.data() as Map<String, dynamic>)["date"],
      placeID: (snapshot.data() as Map<String, dynamic>)["placeID"],
      userID: (snapshot.data() as Map<String, dynamic>)["userID"],
    );
  }

  // placeUser from snapshot:
  PlaceUser _placeUserFromSnapshot(DocumentSnapshot snapshot) {
    return PlaceUser(
      placeUserID: snapshot.id,
      isBookmarked: (snapshot.data() as Map<String, dynamic>)["isBookmarked"],
      isLiked: (snapshot.data() as Map<String, dynamic>)["isLiked"],
    );
  }

  // placeUser list from Snapshot
  List<PlaceUser> _placeUserListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PlaceUser(
        placeUserID: doc.id,
        isBookmarked: (doc.data() as Map<String, dynamic>)["isBookmarked"],
        isLiked: (doc.data() as Map<String, dynamic>)["isLiked"],
      );
    }).toList();
  }

  // get place stream
  Stream<List<Place>> get place {
    return placeCollection.snapshots().map(_placeListFromSnapshot);
  }

  // get userPlace stream
  Stream<List<PlaceUser>> get userPlace {
    return placeUserCollection.snapshots().map(_placeUserListFromSnapshot);
  }

  // get reviews
  /*Stream<List<Review>> get reviews {
    return reviewCollection.snapshots()
    .map(_reviewListFromSnapshot);
  }*/

  // get reviews for a place
  Stream<List<Review>> getReviewsForPlace(String placeID) {
    return reviewCollection
        .where('placeID', isEqualTo: placeID)
        .snapshots()
        .map(_reviewListFromSnapshot);
  }

  // get user review:
  Stream<Review> userReview(String reviewID) {
    return reviewCollection
        .doc(reviewID)
        .snapshots()
        .map(_userReviewFromSnapshot);
  }

  // get placeUser:
  Stream<PlaceUser> placeUser(String placeUserID) {
    return placeUserCollection
        .doc(placeUserID)
        .snapshots()
        .map(_placeUserFromSnapshot);
  }

  // Fetch likes count for a place
  /*Future<int> getPlaceLikes(String placeID) async {
    DocumentSnapshot snapshot = await placeCollection.doc(placeID).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data['likes'] ?? 0;
  }*/

  // Updating the username in reviews when the username changes.
  Future<void> updateUsernameInReviews(
      String userID, String oldUsername, String newUsername) async {
    QuerySnapshot reviewsSnapshot =
        await reviewCollection.where('userID', isEqualTo: userID).get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (QueryDocumentSnapshot reviewDoc in reviewsSnapshot.docs) {
      batch.update(
          reviewCollection.doc(reviewDoc.id), {'username': newUsername});
    }

    await batch.commit();
  }
}
