import 'package:flutter/material.dart';

Widget buildImage(String imageUrl, int index){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: AssetImage(imageUrl),
        fit: BoxFit.cover,
      )
    ),
  );

}