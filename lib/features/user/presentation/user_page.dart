import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_list_test/features/user/application/user_list_controller.dart';
import 'package:user_list_test/features/user/domain/user.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersValue = ref.watch(userListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: usersValue.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _UserError(
          onRetry: () => ref.invalidate(userListControllerProvider),
        ),
        data: (users) => _UserList(users: users),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.image),
            onBackgroundImageError: (error, stackTrace) {},
          ),
          title: Text(user.fullName),
          subtitle: Text(user.email),
        );
      },
    );
  }
}

class _UserError extends StatelessWidget {
  const _UserError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Could not load users.'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
