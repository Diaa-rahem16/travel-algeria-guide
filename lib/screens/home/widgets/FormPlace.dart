import 'dart:io';

import 'package:algerian_touristic_guide_app/models/place.dart';
import 'package:algerian_touristic_guide_app/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// import 'package:algerian_touristic_guide_app/services/database.dart';

class FormPlace extends StatefulWidget {
  @override
  _FormPlaceState createState() => _FormPlaceState();
}

String imageUrl = "";
Future createPlace({required Place place}) async {
  final docUser =
      FirebaseFirestore.instance.collection('place').doc(place.name);

  final json = {
    'placeID': place.placeID,
    'category': place.category,
    'name': place.name,
    'state': place.state,
    'location': place.location,
    'imagePath': imageUrl,
    'description': place.description,
  };

  await docUser.set(json);
}

final CollectionReference placeCollection =
    FirebaseFirestore.instance.collection('place');

class _FormPlaceState extends State<FormPlace> {
  //

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>?>(context) ?? [];

    List<String?> states = places
        .map((place) {
          return place.state;
        })
        .toSet()
        .toList();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'museum', child: Text('Museum')),
                DropdownMenuItem(
                    value: 'restaurant_coffee',
                    child: Text('Restaurant And Coffee')),
                DropdownMenuItem(value: 'others', child: Text('Other Places')),
                DropdownMenuItem(
                    value: 'historical_place', child: Text('Historical Place')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _categoryController.text = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose a category';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'State'),
              items: const [
                DropdownMenuItem(
                    value: 'Constantine', child: Text('Constantine')),
                DropdownMenuItem(value: 'Algiers', child: Text('Algiers')),
                DropdownMenuItem(value: 'Oran', child: Text('Oran')),
                DropdownMenuItem(value: 'Annaba', child: Text('Annaba')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _stateController.text = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose a state';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            ListTile(
                leading: Icon(
                  Icons.add_a_photo,
                  color: kSecondaryClr,
                  size: 45,
                ),
                title: Text(
                  'Add Image ',
                  style: TextStyle(
                    fontSize: 16,
                    color: kSecondaryClr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
                  ImagePicker imagePicker = ImagePicker();
                  final file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  if (file == null) return;

                  // get a reference to storage root
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  // create a ref for the directory to be stored
                  Reference referenceDirImages = referenceRoot.child('places');

                  // create a ref for the image to be stored
                  if (referenceDirImages == null) return;
                  Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);

                  // upload the PNG image to Firebase Storage with the correct content type
                  try {
                    await referenceImageToUpload.putFile(
                      File(file.path!),
                    );
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (e) {
                    // Handle any errors
                  }
                }),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(kPrimearyClr),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20))),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // ...

                  String placeID =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Place place = Place(
                    likes: 0,
                    placeID: placeID,
                    name: _nameController.text,
                    state: _stateController.text,
                    location: _locationController.text,
                    imagePath: _imagePathController.text,
                    description: _descriptionController.text,
                  );
                  createPlace(place: place);
                  // Do something with the Place object
                }
              },
              child: Text(
                'Validate',
                style: TextStyle(
                    color: kBgClr, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
