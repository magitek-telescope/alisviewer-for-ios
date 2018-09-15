import 'dart:async';
import 'package:flutter/material.dart';
import '../http/article.dart';
import '../widgets/article_card.dart';
import '../widgets/topic_cards_section.dart';
import '../widgets/rate_viewer.dart';
import '../widgets/mock_card.dart';

class PopularArticlesPage extends StatefulWidget {
  PopularArticlesPage({Key key}) : super(key: key);
  @override
  _PopularArticlesPageState createState() => new _PopularArticlesPageState();
}

class _PopularArticlesPageState extends State<PopularArticlesPage> {
  Widget _topicCardsSection;
  Widget _rateViewer;
  List<Article> _items = [];
  ArticleClient _articleClient = new ArticleClient();
  List<String> topics = ['crypto', 'gourmet', 'gosyuin'];
  int topicOffset = 0;
  int _page = 1;
  String articleType = 'popular';

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
      if (articleType == 'popular') {
        await Future.wait([
          _articleClient.fetchPopularArticles(topic: topics[topicOffset], page: _page),
          new Future.delayed(new Duration(milliseconds: 600))
        ]);
      } else {
        await Future.wait([
          _articleClient.fetchRecentArticles(topic: topics[topicOffset], page: _page),
          new Future.delayed(new Duration(milliseconds: 600))
        ]);
      }
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

  _toggleArticleType() {
    articleType = articleType == 'popular' ? 'recent': 'popular';
    _page = 1;
    this._loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renderList = [];
    if (_topicCardsSection == null) {
      _topicCardsSection = new TopicCardsView(onChange: (offset) {
        print('hoge');
        setState(() {
          topicOffset = offset;
        });
        Future.delayed(new Duration(milliseconds: 250)).then((_) {this._loadArticles();});
      },);
    }
    if (_rateViewer == null) {
      _rateViewer = new RateViewer();
      renderList.add(_rateViewer);
      // _rateViewer = null;
    }

    renderList.add(_rateViewer);
    renderList.add(_topicCardsSection);
    renderList.addAll(getItemWidgets(this._items));

    return new Scaffold(
      appBar: new AppBar(
        title: Image.network('https://i.imgur.com/JAumQrd.png'),
        backgroundColor: new Color(0xFF454A74),
        elevation: 4.0,
        actions: <Widget>[
          new Center(
            child: new Container(
              width: 30.0,
              height: 30.0,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage('https://alis.to/d/api/info_icon/potato4d/icon/a2981d2a-67ec-4780-86bb-615e97572822.png')
                ),
                borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
              )
            )
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {

            }
          )
        ],
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
      floatingActionButton: new FloatingActionButton(
        onPressed: _toggleArticleType,
        tooltip: 'Toggle',
        backgroundColor: Color(0xFF858DDA),
        child: articleType == 'popular' ? new Icon(Icons.list) : new Icon(Icons.trending_up),
      ),
    );
  }
}
