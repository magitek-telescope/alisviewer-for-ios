import 'package:flutter/material.dart';
import '../http/article.dart';

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

  initState() {
    print('1');
    this._loadArticles();
  }

  final Widget blankBody = new Center(
      child: ListView(children: <Widget>[
    new Center(
      child: const Text('No content.'),
    )
  ]));

  void _loadArticles() async {
    setState(() {
      _items = [];
    });
    try {
      await articleClient.fetchPopularArticles();
    } catch (e) {}
    setState(() {
      _items = articleClient.items;
    });
  }

  Widget _createMockCard() {
    var createMockText = ({double width, double height, double radius}) {
      return new ClipRRect(
          borderRadius: new BorderRadius.all(Radius.circular(radius)),
          child: Container(
              width: width, height: height, color: new Color(0xFFE5E5E5)));
    };

    return new Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: new Card(
            child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ClipRRect(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                child: Container(
                    width: double.infinity,
                    height: 150.0,
                    color: new Color(0xFFE5E5E5))),
            new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: new Row(
                    children: <Widget>[
                      createMockText(width: 120.0, height: 18.0, radius: 4.0)
                    ],
                  ),
                  subtitle: Padding(
                      padding: EdgeInsets.only(top: 12.0, bottom: 0.0),
                      child: new Column(children: [
                        createMockText(
                            width: double.infinity, height: 14.0, radius: 4.0),
                        Container(width: double.infinity, height: 14.0),
                        createMockText(
                            width: double.infinity, height: 14.0, radius: 4.0),
                        Container(width: double.infinity, height: 14.0),
                        createMockText(
                            width: double.infinity, height: 14.0, radius: 4.0),
                        Container(width: double.infinity, height: 14.0),
                        createMockText(
                            width: double.infinity, height: 14.0, radius: 4.0),
                      ])),
                )),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.only(bottom: 12.0),
                    child:
                        createMockText(width: 40.0, height: 12.0, radius: 4.0)),
                new Container(width: 20.0),
              ],
            )
          ],
        )));
  }

  Widget _createCard(Article item) {
    String title = item.title;
    String overview = item.overview;
    String userId = item.userId;
    String articleId = item.articleId;
    int score = item.articleScore;

    Widget cardMainArea = GestureDetector(
      onTap: () {
        print('https://alis.to/$userId/articles/$articleId');
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
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[cardMainArea, cardActionArea],
        )
      )
    );
  }

  Widget _createBody(List<Article> items) {
    List<Widget> itemCardList = [];
    itemCardList = this._items.map((item) => _createCard(item)).toList();

    return new Center(
      child: ListView(
        padding: new EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
        children: itemCardList.length > 0
                ? itemCardList
                : List.generate(5, (i) => _createMockCard())
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
