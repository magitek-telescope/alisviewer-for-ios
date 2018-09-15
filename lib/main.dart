import 'package:flutter/material.dart';
import './pages/poplular_articles_page.dart';

void main() => runApp(new ALISViewer());

class ALISViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ALIS Editor',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new PopularArticlesPage(),
    );
  }
}
