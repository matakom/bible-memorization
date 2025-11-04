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
}

final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return UserRepository(dio);
});