import 'dart:convert';
import 'package:http/http.dart' as http;
import './client.dart';

class Rate {
  double alisToBtc = 0.0;
  double btcToJpy = 0.0;
  double alisToJpy = 0.0;

  Rate({
    this.alisToBtc,
    this.btcToJpy,
    this.alisToJpy
  });
}

class RateClient extends APIClient {
  Rate rate;

  fetchRate() async {
    try {
      final alisToBtcResponse = await http.get('https://www.coinexchange.io/api/v1/getmarketsummary?market_id=538');
      final btcToJpyResponse = await http.get('https://coincheck.com/api/rate/btc_jpy');
      if (alisToBtcResponse.statusCode != 200 || btcToJpyResponse.statusCode != 200) {
        return;
      }
      double alisToBtc = double.parse(json.decode(alisToBtcResponse.body)['result']['LastPrice']);
      double btcToJpy = double.parse(json.decode(btcToJpyResponse.body)['rate']);
      double alisToJpy = btcToJpy * alisToBtc;
      rate = new Rate(alisToBtc: alisToBtc, btcToJpy: btcToJpy, alisToJpy: alisToJpy);
    } catch(e) {
      print('Error in RateClient');
      print(e);
    }
  }
}
