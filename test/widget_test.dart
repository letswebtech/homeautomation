// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smartHome/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}


// Creation date: 16-May-2020
// Entry type: PrivateKeyEntry
// Certificate chain length: 1
// Certificate[1]:
// Owner: C=US, O=Android, CN=Android Debug
// Issuer: C=US, O=Android, CN=Android Debug
// Serial number: 1
// Valid from: Sat May 16 13:56:30 IST 2020 until: Mon May 09 13:56:30 IST 2050
// Certificate fingerprints:
// 	 SHA1: 10:AD:36:9B:BF:F2:4E:0C:65:91:3B:DE:5A:D6:3A:25:25:02:3D:36
// 	 SHA256: 95:D2:9F:FF:F1:A2:60:ED:56:AB:12:17:02:87:36:1E:B3:8D:85:9D:13:29:38:2B:CB:02:10:39:57:C8:38:CD
// Signature algorithm name: SHA1withRSA (weak)
// Subject Public Key Algorithm: 2048-bit RSA key
// Version: 1

// Warning:
// The certificate uses the SHA1withRSA signature algorithm which is considered a security risk. This algorithm will be disabled in a future update.
// The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore /home/kaaju/.android/debug.keystore -destkeystore /home/kaaju/.android/debug.keystore -deststoretype pkcs12".
