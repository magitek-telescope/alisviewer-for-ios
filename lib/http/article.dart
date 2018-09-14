import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import './client.dart';

class Article {
  final String userId;
  final String articleId;
  final String eyeCatchUrl;
  final String title;
  final String overview;
  final int articleScore;

  Article({
    this.userId,
    this.articleId,
    this.eyeCatchUrl,
    this.title,
    this.overview,
    this.articleScore
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      userId: json['user_id'],
      articleId: json['article_id'],
      eyeCatchUrl: json['eye_catch_url'],
      title: json['title'],
      overview: json['overview'],
      articleScore: json['article_score'],
    );
  }
}

class ArticleClient extends APIClient {
  List<Article> items = [];

  Future<void> fetchPopularArticles() async {
    List<Article> items = [];
    final String url = createURL('/articles/popular?topic=crypto&limit=10&page=1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> _rawItems = json.decode(response.body)['Items'];
      _rawItems.forEach((f) {
        if (f != null) {
          var item = Article.fromJson(f);
          if (item != null) {
            items.add(item);
          }
        }
      });
      this.items = items;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
