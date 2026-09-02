import 'package:flutter_test/flutter_test.dart';
import 'package:smart_vehicle_lighting_system/main.dart';

void main() {
  testWidgets(
    'Smart Vehicle Lighting app loads',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const SmartVehicleLightingApp(),
      );

      expect(
        find.text('SMART VEHICLE LIGHTING SYSTEM'),
        findsOneWidget,
      );
    },
  );
}
