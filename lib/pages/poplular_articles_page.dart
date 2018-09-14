import 'package:flutter/material.dart';
import '../entities/article.dart';

class PopularArticlesPage extends StatefulWidget {
  PopularArticlesPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _PopularArticlesPageState createState() => new _PopularArticlesPageState();
}

class _PopularArticlesPageState extends State<PopularArticlesPage> {
  List<Article> _items = [];
  ArticleClient articleClient = new ArticleClient();

  final Widget blankBody = new Center(
    child: ListView(
      children: <Widget>[
        new Center(
          child: const Text('No content.'),
        )
      ]
    )
  );

  void _loadArticles() async {
    setState(() {
      _items = [];
    });

    try {
      await articleClient.fetchPopularArticles();
    } catch(e) {

    }
    setState(() {
      _items = articleClient.items;
    });
  }

  Widget _createCard(Article item) {
    String title = item.title;
    String overview = item.overview;
    int score = item.articleScore;
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ClipRRect(
              borderRadius: new BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0) ),
              child: Image.network(
                item.eyeCatchUrl,
                width: double.infinity,
                height: 150.0,
                fit: BoxFit.cover
              )
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
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(bottom: 12.0),
                  child: new Text('♥ $score', textAlign: TextAlign.right, style: new TextStyle(color: new Color(0xFFAAAAAA)))
                ),
                new Container(width: 20.0),
              ],
            )
          ],
        )
      )
    );
  }

  Widget _createBody(List<Article> items) {
    List<Widget> itemCardList = [];
    if (items == null || items.length == 0) {
      return this.blankBody;
    }
    itemCardList = this._items.map((item) => _createCard(item)).toList();
    return new Center(
      child:
        ListView(
          padding: new EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
          children: itemCardList
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = this._createBody(this._items);

    return new Scaffold(
      appBar: new AppBar(
        title: Image.network('https://i.imgur.com/JAumQrd.png'),
        backgroundColor: new Color(0xFF454A74),
      ),
      body: body,
      floatingActionButton: new FloatingActionButton(
        onPressed: _loadArticles,
        tooltip: 'Increment',
        child: new Icon(Icons.cloud_download),
      ),
    );
  }
}