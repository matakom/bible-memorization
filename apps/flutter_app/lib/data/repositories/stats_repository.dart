import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';
import 'package:flutter_app/data/models/user_stats.dart';

class StatsRepository {
  final Dio _dio;
  StatsRepository(this._dio);

  Future<UserStats> getMyStats() async {
    final response = await _dio.get('/user/stats');
    return UserStats.fromJson(response.data);
  }
  
  Future<UserStats> getFriendStats(String userId) async {
    final response = await _dio.get('/user/$userId/stats');
    return UserStats.fromJson(response.data);
  }
}

// Providers
final statsRepositoryProvider = FutureProvider((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return StatsRepository(dio);
});

final myStatsProvider = FutureProvider<UserStats>((ref) async {
  final repo = await ref.watch(statsRepositoryProvider.future);
  return repo.getMyStats();
});
final friendStatsProvider = FutureProvider.family<UserStats, String>((ref, friendId) async {
  final repo = await ref.watch(statsRepositoryProvider.future);
  return repo.getFriendStats(friendId);
});