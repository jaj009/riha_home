import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riha_home/app/app.dart';

void main() {
  testWidgets('Home dashboard renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RiHaApp()));
    await tester.pumpAndSettle();

    expect(find.text('RiHa Home'), findsOneWidget);
    expect(find.text('Birthdays'), findsOneWidget);
  });
}
