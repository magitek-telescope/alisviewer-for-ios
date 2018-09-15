import 'package:flutter/material.dart';
import '../http/article.dart';
import '../http/url_opener.dart';

class ArticleCard extends StatelessWidget {

  ArticleCard({@required this.item });

  final Article item;

  Widget build(BuildContext context) {
    String title = item.title;
    String overview = item.overview;
    String userId = item.userId;
    String articleId = item.articleId;
    int score = item.articleScore;

    Widget cardMainArea = GestureDetector(
      onTap: () {
        UrlOpener().open('https://alis.to/$userId/articles/$articleId');
      },
      child: new Column(children: <Widget>[
        new ClipRRect(
          borderRadius: new BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
          child: Image.network(item.eyeCatchUrl, width: double.infinity, height: 150.0, fit: BoxFit.cover)
        ),
        new Padding(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('$title'),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 0.0),
              child: Text('$overview……'),
            ),
          )
        ),
      ]),
    );

    Widget cardActionArea = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Padding(
            padding: new EdgeInsets.only(bottom: 12.0),
            child: new Text('♥ $score',
                textAlign: TextAlign.right,
                style: new TextStyle(color: new Color(0xFFAAAAAA)))),
        new Container(width: 20.0),
      ],
    );

    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[cardMainArea, cardActionArea],
        )
      )
    );
  }
}
