import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import '../http/article.dart';
import '../widgets/article_card.dart';
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
  ArticleClient _articleClient = new ArticleClient();
  List<String> topics = ['crypto', 'gourmet', 'gosyuin'];
  ScrollController _scrollController;
  int topicOffset = 0;

  @override
  void initState() {
    super.initState();
    this._loadArticles();
    _scrollController = new ScrollController();
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

  @override
  Widget build(BuildContext context) {
    List<Widget> renderList = [];
    List<Widget> itemCardList = [];
    itemCardList = this._items.map((item) => new ArticleCard(item: item)).toList();

    renderList.add(
      new Container(
        height: 280.0,
        margin: EdgeInsets.only(bottom: 0.0),
        child: GestureDetector(
          onHorizontalDragEnd: (data) {
            if (data.velocity.pixelsPerSecond.dx > 500) {
              if (topicOffset - 1 < 0) return;
              topicOffset = Math.max(topicOffset - 1, 0);
            } else if(data.velocity.pixelsPerSecond.dx < -500) {
              if (topicOffset + 1 >= topics.length) return;
              topicOffset = Math.min(topicOffset + 1, topics.length - 1);
            }
            _scrollController.animateTo(
              topicOffset * MediaQuery.of(context).size.width,
              duration: new Duration(milliseconds: 250),
              curve: Curves.ease
            );
            Future.delayed(new Duration(milliseconds: 250)).then((_) {this._loadArticles();});
            return;
          },
          child: new ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              TopicCard(
                topicName: 'クリプト',
                imageUrl: 'https://img.esa.io/uploads/production/attachments/4699/2018/09/15/11203/6bde5b03-68ee-4fe9-a3ee-36ddfbf48387.png'
              ),
              TopicCard(
                topicName: 'グルメ',
                imageUrl: 'https://img.esa.io/uploads/production/attachments/4699/2018/09/15/11203/e6290305-4311-4333-a6ba-979276ae5cb8.jpeg'
              ),
              TopicCard(
                topicName: '御朱印',
                imageUrl: 'https://img.esa.io/uploads/production/attachments/4699/2018/09/15/11203/f59c2c6e-d77e-4e51-8dea-a020869ce46e.jpeg'
              ),
            ]
          ),
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
            padding: new EdgeInsets.only(bottom: 20.0),
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
