import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_list_test/features/user/domain/user.dart';

const usersUrl = 'https://dummyjson.com/users';

abstract class UserRepository {
  Future<List<User>> fetchUsers();
}

class ApiUserRepository implements UserRepository {
  ApiUserRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<User>> fetchUsers() async {
    final response = await _dio.get<Map<String, dynamic>>(usersUrl);

    final jsonList = response.data!['users'] as List<dynamic>;

    return jsonList
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ApiUserRepository(Dio());
});
