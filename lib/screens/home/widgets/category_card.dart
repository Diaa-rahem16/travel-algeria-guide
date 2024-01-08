import 'package:algerian_touristic_guide_app/utilities/colors.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback press;
  bool isClicked = false;
  CategoryCard({
    Key? key,
    required this.title,
    required this.image,
    required this.press,
    required this.isClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Ink(
          color: isClicked ? Colors.grey[600] : kWhiteClr,
          // Change this to your desired color
          child: InkWell(
            hoverColor: Colors.blue, // Change this to your desired hover color
            borderRadius: BorderRadius.circular(180),
            onTap: press,

            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: isClicked ? kSecondaryClr : kWhiteClr,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(image),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
