import 'package:attendance_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LogoutDialog tampil dan tombol Batal menutupnya', (
    tester,
  ) async {
    bool? dialogResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                dialogResult = await showDialog<bool>(
                  context: context,
                  builder: (_) => const LogoutDialog(),
                );
              },
              child: const Text('Buka Dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari akun?'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(find.text('Keluar dari akun?'), findsNothing);
    expect(dialogResult, isFalse);
  });
}
