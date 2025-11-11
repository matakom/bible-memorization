import 'package:dio/dio.dart';
import 'package:flutter_app/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';

class UserRepository {
  final Dio _dio;
  UserRepository(this._dio);

  Future<void> setLocale(String locale) async {
    await _dio.patch('/user/settings', data: {'locale': locale});
  }

  Future<void> setTheme(String theme) async {
    await _dio.patch('/user/settings', data: {'theme': theme});
  }

  Future<AppUser> getUserData() async {
    final response = await _dio.get('/user');
    return AppUser.fromJson(response.data as Map<String, dynamic>);
  }
}

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return UserRepository(dio);
});
