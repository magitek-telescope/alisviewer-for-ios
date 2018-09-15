import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../http/article.dart';
import '../http/url_opener.dart';
import '../widgets/topic_card.dart';
import '../widgets/mock_card.dart';

class PopularArticlesPage extends StatefulWidget {
  PopularArticlesPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PopularArticlesPageState createState() => new _PopularArticlesPageState();
}

class _PopularArticlesPageState extends State<PopularArticlesPage> {
  List<Article> _items = [];
  ArticleClient articleClient = new ArticleClient();

  @override
  void initState() {
    super.initState();
    this._loadArticles();
  }

  void _loadArticles() async {
    setState(() {
      _items = [];
    });
    try {
      await Future.wait([
        articleClient.fetchPopularArticles(),
        new Future.delayed(new Duration(milliseconds: 600))
      ]);
    } catch (e) {}
    setState(() {
      _items = articleClient.items;
    });
  }

  Widget _createCard(Article item) {
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

  @override
  Widget build(BuildContext context) {
    List<Widget> renderList = [];
    List<Widget> itemCardList = [];
    itemCardList = this._items.map((item) => _createCard(item)).toList();

    renderList.add(
      new Container(
        height: 240.0,
        margin: EdgeInsets.only(bottom: 20.0, top: 10.0, right: 10.0),
        child: new ListView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TopicCard(imageUrl: 'https://img.esa.io/uploads/production/attachments/4699/2018/09/15/11203/6bde5b03-68ee-4fe9-a3ee-36ddfbf48387.png',),
            TopicCard(imageUrl: 'https://img.esa.io/uploads/production/attachments/4699/2018/09/15/11203/e6290305-4311-4333-a6ba-979276ae5cb8.jpeg',),
            TopicCard(imageUrl: 'https://img.esa.io/uploads/production/attachments/4699/2018/09/15/11203/f59c2c6e-d77e-4e51-8dea-a020869ce46e.jpeg',),
          ]
        )
      )
    );

    renderList.addAll(itemCardList.length > 0
                        ? itemCardList
                        : List.generate(5, (i) => new MockCard()));

    return new Scaffold(
      appBar: new AppBar(
        title: Image.network('https://i.imgur.com/JAumQrd.png'),
        backgroundColor: new Color(0xFF454A74),
      ),

      body: new Center(
        child: new RefreshIndicator(
          onRefresh: () async {
            try {
              this._loadArticles();
            } catch(e) {}
            return null;
          },
          child: new ListView(
            scrollDirection: Axis.vertical,
            padding: new EdgeInsets.only(top: 20.0, bottom: 20.0),
            children: renderList
          )
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _loadArticles,
        tooltip: 'Increment',
        child: new Icon(Icons.cloud_download),
      ),
    );
  }
}
