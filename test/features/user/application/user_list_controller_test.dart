import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_list_test/features/user/application/user_list_controller.dart';
import 'package:user_list_test/features/user/data/user_repository.dart';
import 'package:user_list_test/features/user/domain/user.dart';

import '../fake_user_repository.dart';

void main() {
  // A container where the real repository is replaced by the given one.
  // ProviderContainer.test disposes the container when the test ends.
  ProviderContainer makeProviderContainer(UserRepository repository) {
    return ProviderContainer.test(
      overrides: [userRepositoryProvider.overrideWithValue(repository)],
      // Riverpod retries a failed provider by default.
      // Turn it off so the failure test ends right after the first error.
      retry: (retryCount, error) => null,
    );
  }

  // Listens to the controller and keeps every state it emits, in order.
  List<AsyncValue<List<User>>> recordStates(ProviderContainer container) {
    final states = <AsyncValue<List<User>>>[];
    container.listen(
      userListControllerProvider,
      (previous, next) => states.add(next),
      fireImmediately: true,
    );
    return states;
  }

  group('UserListController', () {
    test('fetch users success', () async {
      // Arrange
      final repository = FakeUserRepository(users: fakeUsers);
      final container = makeProviderContainer(repository);
      final states = recordStates(container);

      // Act
      await container.read(userListControllerProvider.future);

      // Assert: loading first, then the five users.
      expect(states, hasLength(2));
      expect(states[0], isA<AsyncLoading<List<User>>>());
      expect(states[1], isA<AsyncData<List<User>>>());
      expect(states[1].value, fakeUsers);
      expect(states[1].value, hasLength(5));
      expect(repository.fetchCount, 1);
    });

    test('fetch users failure', () async {
      // Arrange
      final exception = Exception('fail');
      final repository = FakeUserRepository(error: exception);
      final container = makeProviderContainer(repository);
      final states = recordStates(container);

      // Act
      await expectLater(
        container.read(userListControllerProvider.future),
        throwsA(exception),
      );

      // Assert: loading first, then the error from the repository.
      expect(states, hasLength(2));
      expect(states[0], isA<AsyncLoading<List<User>>>());
      expect(states[1], isA<AsyncError<List<User>>>());
      expect(states[1].error, exception);
      expect(repository.fetchCount, 1);
    });
  });
}
