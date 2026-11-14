import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_list_test/features/user/domain/user.dart';

const usersUrl = 'https://dummyjson.com/users';

/// Where the list of users comes from.
///
/// The controller only knows this interface, so a test can give it a fake.
abstract class UserRepository {
  Future<List<User>> fetchUsers();
}

/// Real repository: reads the users from the dummyjson API.
class ApiUserRepository implements UserRepository {
  ApiUserRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<User>> fetchUsers() async {
    final response = await _dio.get<Map<String, dynamic>>(usersUrl);

    // The API wraps the list: { "users": [...], "total": 208, ... }
    final jsonList = response.data!['users'] as List<dynamic>;

    return jsonList
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

/// Tests override this provider with a fake repository.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ApiUserRepository(Dio());
});
