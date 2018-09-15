import 'package:flutter/material.dart';

class PlaceReactange extends StatelessWidget {

  PlaceReactange({@required this.width, @required this.height, @required this.radius });

  final double width;
  final double height;
  final double radius;

  Widget build(BuildContext context) {
    return new ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(radius)),
      child: Container(
        width: width, height: height, color: new Color(0xFFE5E5E5)
      )
    );
  }
}
