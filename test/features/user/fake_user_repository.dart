import 'package:user_list_test/features/user/data/user_repository.dart';
import 'package:user_list_test/features/user/domain/user.dart';

const fakeUsers = [
  User(
    id: 1,
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@example.com',
    image: 'https://example.com/emily.png',
  ),
  User(
    id: 2,
    firstName: 'Michael',
    lastName: 'Williams',
    email: 'michael.williams@example.com',
    image: 'https://example.com/michael.png',
  ),
  User(
    id: 3,
    firstName: 'Sophia',
    lastName: 'Brown',
    email: 'sophia.brown@example.com',
    image: 'https://example.com/sophia.png',
  ),
  User(
    id: 4,
    firstName: 'James',
    lastName: 'Davis',
    email: 'james.davis@example.com',
    image: 'https://example.com/james.png',
  ),
  User(
    id: 5,
    firstName: 'Emma',
    lastName: 'Miller',
    email: 'emma.miller@example.com',
    image: 'https://example.com/emma.png',
  ),
];

class FakeUserRepository implements UserRepository {
  FakeUserRepository({this.users = const [], this.error});

  final List<User> users;
  final Exception? error;
  int fetchCount = 0;

  @override
  Future<List<User>> fetchUsers() async {
    fetchCount++;

    final error = this.error;
    if (error != null) {
      throw error;
    }

    return users;
  }
}
