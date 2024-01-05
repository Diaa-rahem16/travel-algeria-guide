//import 'package:flutter/material.dart';
import 'package:algerian_touristic_guide_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Creating a private FirebaseAuth object
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create a user object based on a Firebase User.
  AppUser? _userFromFirebaseUser(User? user){
    return user != null ? AppUser(uid: user.uid, fullName: user.displayName) : null;
  }

  //Auth change user stream
  Stream<AppUser?> get user {
    return _auth.userChanges()
    //.map((User? user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  //sign in anonymously
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously(); //await simply indicates the function execution will be paused until the Future object completes and returns a result. 
      User user = result.user!;
      return _userFromFirebaseUser(user);
    }catch(e){
      //print(e.toString());
      return null;
    }
  }
  //sign in by email/password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      //print(user);
      return _userFromFirebaseUser(user);
    }catch(e){
      //print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String fullName) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      await user.updateDisplayName(fullName);
      //print(user);
      return _userFromFirebaseUser(user);
    }catch(e){
      //print(e.toString());
      return null;
    }
  }

  //Sign Out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      //print(e.toString());
      return null;
    }
  }

  // Function to get the current user's email
  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  // Function to update the user's displayName
  Future updateUserName(String? name) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
    } catch (e) {
      return null;
    }
  }

  // Function to update the user's email
  Future updateUserEmail(String newEmail) async {
    /*try {
      await _auth.currentUser!.updateEmail(newEmail);
    } catch (e) {
      //print(e);
      return null;
    }*/
    await _auth.currentUser!.updateEmail(newEmail);
  }

  Future updatePassword(String currentPassword, String newPassword) async {
    // Reauthenticate the user with their current password
    AuthCredential credential = EmailAuthProvider.credential(
      email: _auth.currentUser?.email ?? '',
      password: currentPassword,
    );
    await _auth.currentUser?.reauthenticateWithCredential(credential);

    // If reauthentication is successful, update the password
    await _auth.currentUser?.updatePassword(newPassword);
    //print("Error updating password: $e");
    return null;
  }

  
}