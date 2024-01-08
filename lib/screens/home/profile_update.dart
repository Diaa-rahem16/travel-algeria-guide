import 'package:algerian_touristic_guide_app/models/user.dart';
import 'package:algerian_touristic_guide_app/services/auth.dart';
import 'package:algerian_touristic_guide_app/services/database.dart';
import 'package:algerian_touristic_guide_app/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:algerian_touristic_guide_app/shared/constants.dart';
import 'package:provider/provider.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String? fullName;
  String? newEmail;
  String? currentPassword;
  String? newPassword1;
  String? newPassword2;
  String? errorEmail = "";
  String? errorPassword = "";
  String? errorFullName = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    //String? fullNameCheck = user!.fullName;
    //newEmail = _auth.getUserEmail();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          children: [
            // update name form
            Form(
              key: _formKeyName,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHANGE YOUR NAME",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: kPrimearyClr,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Change your name',
                        icon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: kPrimearyClr,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                      ),
                      initialValue: user!.fullName,
                      validator: (val) => val!.isEmpty
                          ? 'The change name field cannot be empty!'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                        });
                      }),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(kPrimearyClr),
                      fixedSize:
                          MaterialStateProperty.all(const Size(200.0, 30.0)),
                    ),
                    child: const Text(
                      'Update Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        errorFullName = "";
                      });
                      if (_formKeyName.currentState!.validate()) {
                        if (fullName == null || fullName == user.fullName) {
                          setState(() {
                            errorFullName = "You already has that name";
                          });
                        } else {
                          DatabaseService().updateUsernameInReviews(
                              user.uid, user.fullName!, fullName!);
                          dynamic result =
                              _auth.updateUserName(fullName ?? user.fullName);
                          if (result == null) {
                            setState(() {
                              errorFullName =
                                  "Could not update your name! Try again later";
                            });
                          } else {
                            setState(() {
                              errorFullName =
                                  "Your name has been updated successfully!";
                            });
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    errorFullName ?? "",
                    style: TextStyle(
                      color: errorFullName ==
                              "Your name has been updated successfully!"
                          ? Colors.green[700]
                          : const Color.fromARGB(248, 180, 8, 8),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: kPrimearyClr,
                thickness: 3.0,
              ),
            ),
            // update email form
            Form(
              key: _formKeyEmail,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHANGE YOUR EMAIL",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: kPrimearyClr,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      initialValue: _auth.getUserEmail(),
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Change your email',
                        icon: const Icon(Icons.email),
                      ),
                      validator: (val) => val!.isEmpty
                          ? 'The change email field cannot be empty!'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          newEmail = val;
                        });
                      }),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(kPrimearyClr),
                      fixedSize:
                          MaterialStateProperty.all(const Size(200.0, 30.0)),
                    ),
                    child: const Text(
                      'Update Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        errorEmail = "";
                      });
                      if (_formKeyEmail.currentState!.validate()) {
                        if (newEmail == null ||
                            newEmail == _auth.getUserEmail()) {
                          setState(() {
                            errorEmail = "You already has that email";
                          });
                        } else {
                          try {
                            await _auth.updateUserEmail(newEmail!);
                            setState(() {
                              errorEmail =
                                  "Your email has been updated successfully!";
                            });
                          } catch (e) {
                            setState(() {
                              // Here, set the error message based on the caught exception
                              errorEmail = "Please enter a valid email!";
                            });
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    errorEmail ?? "",
                    style: TextStyle(
                      color: errorEmail ==
                              "Your email has been updated successfully!"
                          ? Colors.green[700]
                          : const Color.fromARGB(248, 180, 8, 8),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(
                color: kPrimearyClr,
                thickness: 3.0,
              ),
            ),
            // update Password form
            Form(
              key: _formKeyPassword,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHANGE YOUR Password",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: kPrimearyClr,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Current Password',
                        icon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 8
                          ? 'A password cannot be less than 8 characters!'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          currentPassword = val;
                        });
                      }),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'New Password',
                        icon: const Icon(Icons.lock_reset),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 8
                          ? 'A password cannot be less than 8 characters!'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          newPassword1 = val;
                        });
                      }),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Confirm New Password',
                        icon: const Icon(Icons.lock_reset),
                      ),
                      obscureText: true,
                      validator: (val) => val!.length < 8
                          ? 'A password cannot be less than 8 characters!'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          newPassword2 = val;
                        });
                      }),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(kPrimearyClr),
                      fixedSize:
                          MaterialStateProperty.all(const Size(200.0, 30.0)),
                    ),
                    child: const Text(
                      'Update Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        errorPassword = "";
                      });
                      if (_formKeyPassword.currentState!.validate()) {
                        if (newPassword1 == currentPassword &&
                            newPassword1 == newPassword2) {
                          setState(() {
                            errorPassword =
                                "The current password cannot be the same as the new one.";
                          });
                        } else if (newPassword1 != newPassword2) {
                          setState(() {
                            errorPassword = "New passwords do not match!";
                          });
                        } else {
                          try {
                            await _auth.updatePassword(
                                currentPassword!, newPassword1!);
                            setState(() {
                              errorPassword =
                                  "Your password has been updated successfully!";
                            });
                          } catch (e) {
                            setState(() {
                              errorPassword = "Could not update your password";
                            });
                          }
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    errorPassword ?? "",
                    style: TextStyle(
                      color: errorPassword ==
                              "Your password has been updated successfully!"
                          ? Colors.green[700]
                          : const Color.fromARGB(248, 180, 8, 8),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
