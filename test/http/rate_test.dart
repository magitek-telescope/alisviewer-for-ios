import 'package:test/test.dart';
import '../../lib/http/rate.dart';

void main() {
  test('fetchRate', () async {
    // FIXME: Implement DI system
    final RateClient rateClient = new RateClient();
    await rateClient.fetchRate();
    Rate rate = rateClient.rate;
    expect(rate.alisToJpy == 0.0, false);
    expect(rate.alisToBtc== 0.0, false);
    expect(rate.btcToJpy == 0.0, false);
  });
}
