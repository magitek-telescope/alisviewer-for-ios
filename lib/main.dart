import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class Article {
  final String articleId;
  final String eyeCatchUrl;
  final String title;
  final String overview;
  final int articleScore;

  Article({this.articleId, this.eyeCatchUrl, this.title, this.overview, this.articleScore});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleId: json['article_id'],
      eyeCatchUrl: json['eye_catch_url'],
      title: json['title'],
      overview: json['overview'],
      articleScore: json['article_score'],
    );
  }
}

class ArticleResponse {}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
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
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  List<Article> _items = [];


  void _loadArticles() async {
    setState(() {
      _items = [];
    });
    List<Article> items = [];
    final response = await http.get(
        'https://alis.to/api/articles/popular?topic=crypto&limit=10&page=1');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> _rawItems = json.decode(response.body)['Items'];
      _rawItems.forEach((f) {
        if (f != null) {
          var item = Article.fromJson(f);
          if (item != null) {
            print(item);
            items.add(item);
          }
        }
      });
      print('items');
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
    setState(() {
      _items = items;
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    var children = null;
    if (this._items != null && this._items.length > 0) {
      children = this._items.map((item) {
        print(item);
        return new Padding(
          padding: new EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
          child: _createCard(item)
        );
      }).toList();
    }

    var body = new Center(
      child: const Text('No content.'),
    );
    if (children != null) {
      body = new Center(
        child:
          ListView(
            padding: new EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
            children: List.generate(
              this._items.length,
              (i) => _createCard(this._items[i])
            )
          )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: Image.network('https://i.imgur.com/JAumQrd.png'),
        backgroundColor: new Color(0xFF454A74),
      ),
      body: body,
      // body: new Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: children != null ?
      //     ListView(
      //       children: List.generate(
      //         this._items.length,
      //         (i) => _createCard(this._items[i])
      //       )
      //     ) : <Widget>[],
      // ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _loadArticles,
        tooltip: 'Increment',
        child: new Icon(Icons.cloud_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
