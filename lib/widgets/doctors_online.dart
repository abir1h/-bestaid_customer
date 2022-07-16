import 'package:best_aid_customer/utils/data.dart';
import 'package:flutter/material.dart';

Widget doctorsOnline({double height, double width}) {
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: doctorImage.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.01),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  doctorImage[index],
                ),
              ),
              Positioned(
                left: width * 0.125,
                top: height * 0.0675,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                ),
              ),
              Positioned(
                left: width *0.13,
                top: height * 0.07,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        );
      });
}
