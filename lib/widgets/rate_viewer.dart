import 'dart:convert';
import 'dart:async';
import '../http/rate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RateViewer extends StatefulWidget {
  RateViewer();
  Rate rate = new Rate();

  Rate getRate() {
    return this.rate;
  }

  void setRate(Rate _rate) {
    this.rate = _rate;
  }

  @override
  _RateViewerState createState() =>
      new _RateViewerState();
}

class _RateViewerState extends State<RateViewer> {
  Rate rate;
  final RateClient rateClient = new RateClient();

  @override
  initState() {
    super.initState();
    this.rate = widget.getRate();
    this.fetchRate();
  }

  void setRateData({ double alisToJpy, double alisToBtc, double btcToJpy }) {
    Rate _rate = rate;
    if (alisToJpy != null) {
      rate.alisToJpy = alisToJpy;
    }
    if (alisToBtc != null) {
      rate.alisToBtc = alisToBtc;
    }
    if (btcToJpy != null) {
      rate.btcToJpy = btcToJpy;
    }
    widget.setRate(_rate);
    setState(() {
      rate = _rate;
    });
  }

  void fetchRate() async {
    try {
      await rateClient.fetchRate();
      print(rateClient.rate);
      this.setRateData(
        alisToJpy: rateClient.rate.alisToJpy,
        alisToBtc: rateClient.rate.alisToBtc,
        btcToJpy: rateClient.rate.btcToJpy
      );
    } catch(e) {
      print('error');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double alisToJpy = this.rate.alisToJpy;
    return new Container(
      width: double.infinity,
      height: 50.0,
      color: new Color(0xFF151015),
      child: new Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Image.network(
              'https://raw.githubusercontent.com/AlisProject/branding/master/logo/logo_circle_a_transparent_256.png',
              width: 40.0,
              height: 40.0
            ),
            new Container(width: 4.0),
            Text(
              '${alisToJpy != null ? alisToJpy : '0.00000000'} JPY / ALIS',
              style: new TextStyle(
                color: new Color(0xFFE0E0E0),
                fontSize: 14.0,
              )
            )
          ]
        )
      )
    );
  }
}
