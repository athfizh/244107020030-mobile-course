import 'package:flutter_test/flutter_test.dart';

import 'package:profile_card/main.dart';

void main() {
  testWidgets('DashboardApp renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const DashboardApp());
    expect(find.text('Student Dashboard'), findsOneWidget);
  });
}
