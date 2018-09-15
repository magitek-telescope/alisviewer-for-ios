import 'dart:async';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import './topic_card.dart';

class DoubleHolder {
  double value = 0.0;
}

class TopicOffsetHolder {
  int value = 0;
}

class TopicCardsView extends StatefulWidget {
  final DoubleHolder offset = new DoubleHolder();
  final TopicOffsetHolder topicOffset = new TopicOffsetHolder();
  final Function onChange;

  TopicCardsView({ this.onChange });

  double getOffsetMethod() {
    return offset.value;
  }

  int getTopicOffset() {
    return topicOffset.value;
  }

  void setOffsetMethod(double val) {
    offset.value = val;
  }

  void setTopicOffset(int id) {
    topicOffset.value = id;
  }

  @override
  _TopicCardsViewState createState() =>
      new _TopicCardsViewState();
}

class _TopicCardsViewState extends State<TopicCardsView> {
  ScrollController _scrollController;
  List<String> topics = ['crypto', 'gourmet', 'gosyuin'];

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(
      initialScrollOffset: widget.getOffsetMethod()
    );
  }

  @override
  Widget build(BuildContext context) {
    int topicOffset = widget.getTopicOffset();
    return new Container(
      height: 270.0,
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
          widget.setTopicOffset(topicOffset);
          if(widget.onChange != null) {
            widget.onChange(topicOffset);
          }
          _scrollController.animateTo(
            topicOffset * MediaQuery.of(context).size.width,
            duration: new Duration(milliseconds: 250),
            curve: Curves.ease
          );
          // Future.delayed(new Duration(milliseconds: 250)).then((_) {this._loadArticles();});
          return;
        },
        child: new NotificationListener (
          onNotification: (notification) {
            if (notification is ScrollNotification) {
              widget.setOffsetMethod(notification.metrics.pixels);
              // print(new Math.Random().nextInt(100));
            }
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
  }
}
