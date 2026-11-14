import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_list_test/features/user/data/user_repository.dart';
import 'package:user_list_test/features/user/domain/user.dart';

/// Loads the list of users from the repository.
///
/// The state is an AsyncValue, so it is loading first,
/// then data (the users) or error (the exception).
class UserListController extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() {
    final repository = ref.watch(userRepositoryProvider);
    return repository.fetchUsers();
  }
}

final userListControllerProvider =
    AsyncNotifierProvider.autoDispose<UserListController, List<User>>(
      UserListController.new,
    );
