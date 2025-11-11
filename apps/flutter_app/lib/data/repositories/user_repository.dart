import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/security_context_provider.dart';

class UserRepository {
  final Dio _dio;
  UserRepository(this._dio);

  Future<void> checkHealth() async {
    await _dio.get('/health');
  }

  Future<void> setLocale(String locale) async {
    await _dio.patch('/user/settings', data: {'locale': locale});
  }

  Future<void> setTheme(String theme) async {
    await _dio.patch('/user/settings', data: {'theme': theme});
  }

  Future<Map<String, String>> getUserSettings() async {
    final response = await _dio.get('/user/settings');
    final data = response.data as Map<String, dynamic>;
    return {
      'language': data['language'] as String,
      'theme': data['theme'] as String,
    };
  }

  Future<String> getCode() async {
    final response = await _dio.get('/user/code');
    final data = response.data as Map<String, dynamic>;
    return data['friendCode'];
  }
}

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return UserRepository(dio);
});
