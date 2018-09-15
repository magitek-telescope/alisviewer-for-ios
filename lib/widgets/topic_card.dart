import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TopicCard extends StatelessWidget {

  TopicCard({@required this.topicName, @required this.imageUrl });
  final topicName;
  final imageUrl;

  @override
  Widget build(BuildContext context) {
    final double height = 260.0;
    Widget coverImage = new ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(0.0)),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: height - 20.0,
        fit: BoxFit.cover
      )
    );

    BoxDecoration shadow = new BoxDecoration(
      boxShadow: [new BoxShadow(
        color: new Color(0x22000000),
        blurRadius: 6.0,
      ),]
    );

    Widget titleBox = new ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
      child: new Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
        decoration: new BoxDecoration(color: new Color(0xFFFFFFFF)),
        child: new Text(
          topicName,
          textAlign: TextAlign.center,
            style: new TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        )
      )
    );


    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          coverImage,
          Positioned(child: new Container(
            decoration: shadow,
            child: titleBox
          ), bottom: 8.0)

        ]
      )
    );
  }
}
