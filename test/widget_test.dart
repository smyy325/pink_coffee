import 'package:coffee/main.dart';
import 'package:coffee/services/mock_siparis_servisi.dart';
import 'package:coffee/services/yerel_siparis_deposu.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('PinkCoffeeApp açılışta sipariş listesini yükler', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      PinkCoffeeApp(
        servis: MockSiparisServisi(gecikme: Duration.zero),
        yerelDepo: YerelSiparisDeposu(prefs),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PinkCoffee • Sipariş Takip'), findsOneWidget);
    expect(find.text('V60 Ethiopia Yirgacheffe'), findsOneWidget);
  });
}
