import 'package:flutter_test/flutter_test.dart';
import 'package:whoswho/main.dart';

void main() {
  testWidgets('WhosWho app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const WhosWhoApp());

    expect(find.text('WhosWho'), findsOneWidget);
  });
}