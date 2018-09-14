import 'package:flutter/material.dart';
import './entities/article.dart';

void main() => runApp(new ALISViewer());

class ALISViewer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ALIS Editor',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'ALIS Editor Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> _items = [];
  ArticleClient articleClient = new ArticleClient();

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

  @override
  Widget build(BuildContext context) {

    List<Widget> itemCardList = [];
    Widget body = new Center(
      child: ListView(
        children: <Widget>[
          new Center(
            child: const Text('No content.'),
          )
        ]
      )
    );

    if (this._items != null && this._items.length > 0) {
      itemCardList = this._items.map((item) => _createCard(item)).toList();
    }

    if (itemCardList.length > 0) {
      body = new Center(
        child:
          ListView(
            padding: new EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
            children: itemCardList
          )
      );
    }

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
