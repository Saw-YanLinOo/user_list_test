import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_list_test/features/user/data/user_repository.dart';
import 'package:user_list_test/main.dart';

import '../../user/fake_user_repository.dart';

void main() {
  Widget makeApp() {
    return ProviderScope(
      overrides: [
        userRepositoryProvider.overrideWithValue(
          FakeUserRepository(users: fakeUsers),
        ),
      ],
      child: const MainApp(),
    );
  }

  group('HomePage', () {
    testWidgets('Home tab shows the users', (tester) async {
      await tester.pumpWidget(makeApp());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Users'), findsOneWidget);
      expect(find.text('Emily Johnson'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(5));
    });

    testWidgets('Profile tab is empty', (tester) async {
      await tester.pumpWidget(makeApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('app bar uses the deep blue primary color', (tester) async {
      await tester.pumpWidget(makeApp());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(NavigationBar));
      final theme = Theme.of(context);

      expect(theme.colorScheme.primary, deepBlue);
      expect(theme.appBarTheme.backgroundColor, deepBlue);
    });
  });
}
