import 'package:flutter/material.dart';

class TopicCard extends StatelessWidget {

  TopicCard({@required this.imageUrl });
  final imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      width: MediaQuery.of(context).size.width - 20.0,
      height: 240.0,
      child: new ClipRRect(
        borderRadius: new BorderRadius.all(Radius.circular(10.0)),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: 240.0,
          fit: BoxFit.cover
        )
      ),
    );
  }
}
