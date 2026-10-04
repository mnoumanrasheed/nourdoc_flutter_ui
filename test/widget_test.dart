import 'package:flutter_test/flutter_test.dart';
import 'package:nourdoc_ui/main.dart';

void main() {
  testWidgets('shows the NourDoc doctor signup screen', (tester) async {
    await tester.pumpWidget(const NourDocApp());

    expect(find.text('NourDoc'), findsOneWidget);
    expect(find.text('Doctor Signup'), findsOneWidget);
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
