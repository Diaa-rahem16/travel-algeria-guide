import 'package:algerian_touristic_guide_app/models/user.dart';
import 'package:algerian_touristic_guide_app/screens/authenticate/authenticate.dart';
import 'package:algerian_touristic_guide_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser?>(context);
    //print(user);


    //return either Home or Authenticate widgets
    if(user == null){
      return const Authenticate();
    }else{
      return const Home();
    }
  }
}