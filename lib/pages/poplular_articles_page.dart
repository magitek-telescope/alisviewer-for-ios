import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import '../http/article.dart';
import '../widgets/article_card.dart';
import '../widgets/topic_cards_section.dart';
import '../widgets/mock_card.dart';

class PopularArticlesPage extends StatefulWidget {
  PopularArticlesPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PopularArticlesPageState createState() => new _PopularArticlesPageState();
}

class _PopularArticlesPageState extends State<PopularArticlesPage> {
  Widget _topicCardsSection;
  List<Article> _items = [];
  ArticleClient _articleClient = new ArticleClient();
  List<String> topics = ['crypto', 'gourmet', 'gosyuin'];
  int topicOffset = 0;

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
        _articleClient.fetchPopularArticles(topics[topicOffset]),
        new Future.delayed(new Duration(milliseconds: 600))
      ]);
    } catch (e) {}
    setState(() {
      _items = _articleClient.items;
    });
  }

  List<Widget> getItemWidgets(List<Article> items) {
    List<Widget> itemCardList = [];
    itemCardList = items.map((item) => new ArticleCard(item: item)).toList();
    return itemCardList.length > 0 ? itemCardList : List.generate(5, (i) => new MockCard());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renderList = [];
    // if (_topicCardsSection == null) {
      _topicCardsSection = new TopicCardsView();
    // }

    renderList.add(_topicCardsSection);
    renderList.addAll(getItemWidgets(this._items));

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
            padding: new EdgeInsets.only(bottom: 20.0),
            children: renderList
          )
        ),
      ),
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: _loadArticles,
      //   tooltip: 'Increment',
      //   child: new Icon(Icons.cloud_download),
      // ),
    );
  }
}
