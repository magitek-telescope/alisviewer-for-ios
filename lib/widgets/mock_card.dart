import 'package:flutter/material.dart';
import './place_reactange.dart';

class MockCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ClipRRect(
              borderRadius: new BorderRadius.only(topLeft: Radius.circular(4.0),topRight: Radius.circular(4.0)),
              child: Container(
                width: double.infinity,
                height: 150.0,
                color: new Color(0xFFE5E5E5)
              )
            ),
            new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: new Row(
                  children: <Widget>[
                    PlaceReactange(width: 120.0, height: 18.0, radius: 4.0)
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 0.0),
                  child: new Column(
                    children: [
                      PlaceReactange(width: double.infinity, height: 14.0, radius: 4.0),
                      Container(width: double.infinity, height: 14.0),
                      PlaceReactange(width: double.infinity, height: 14.0, radius: 4.0),
                      Container(width: double.infinity, height: 14.0),
                      PlaceReactange(width: double.infinity, height: 14.0, radius: 4.0),
                      Container(width: double.infinity, height: 14.0),
                      PlaceReactange(width: double.infinity, height: 14.0, radius: 4.0),
                    ]
                  )
                ),
              )
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(bottom: 12.0),
                  child: PlaceReactange(width: 40.0, height: 12.0, radius: 4.0)
                ),
                new Container(width: 20.0),
              ],
            )
          ],
        )
      )
    );
  }
}
