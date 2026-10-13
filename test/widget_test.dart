import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculatorapp/main.dart';

Future<void> startCalculator(WidgetTester tester) async {
  await tester.pumpWidget(const CalculatorApp());
  expect(find.byKey(const Key('startup-screen')), findsOneWidget);
  await tester.pump(const Duration(milliseconds: 3500));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('startup screen opens the calculator after 3.5 seconds', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.byKey(const Key('startup-screen')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.byKey(const Key('startup-screen')), findsOneWidget);
    expect(find.byKey(const Key('mobile-calculator-layout')), findsNothing);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(const Key('mobile-calculator-layout')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('startup-screen')), findsNothing);
  });

  testWidgets('phone keypad calculates and records history', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await startCalculator(tester);

    expect(find.byKey(const Key('mobile-calculator-layout')), findsOneWidget);
    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('result'))).data, '5');

    await tester.tap(find.byKey(const Key('show-history')));
    await tester.pumpAndSettle();
    expect(find.text('2 + 3 = 5'), findsNWidgets(2));
  });

  testWidgets('scientific and memory actions use the display value', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await startCalculator(tester);

    await tester.tap(find.text('9'));
    await tester.tap(find.text('√'));
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const Key('result'))).data, '3');

    await tester.tap(find.text('M+'));
    await tester.tap(find.text('AC'));
    await tester.tap(find.text('MR'));
    await tester.pump();
    expect(tester.widget<Text>(find.byKey(const Key('result'))).data, '3');
  });

  testWidgets('clear resets the expression and display', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await startCalculator(tester);

    await tester.tap(find.text('8'));
    await tester.tap(find.text('−'));
    await tester.tap(find.text('4'));
    await tester.tap(find.text('='));
    await tester.tap(find.text('AC'));
    await tester.pump();

    expect(tester.widget<Text>(find.byKey(const Key('result'))).data, '0');
    expect(find.text('8 - 4 = 4'), findsNothing);
  });
}
