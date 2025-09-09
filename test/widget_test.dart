import 'package:flutter_test/flutter_test.dart';
import 'package:special_one_student/main.dart';

void main() {
  testWidgets('App builds without crashing', (tester) async {
    await tester.pumpWidget(const SpecialOneApp());
    await tester.pumpAndSettle();
    expect(find.byType(SpecialOneApp), findsOneWidget);
  });
}
