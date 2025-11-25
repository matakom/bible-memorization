import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';

class PracticeResult {
  final String verseId;
  final int grade; // 0-5
  final String exerciseType;
  final int durationSeconds;

  PracticeResult({
    required this.verseId,
    required this.grade,
    required this.exerciseType,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() => {
        'verseId': verseId,
        'grade': grade,
        'exerciseType': exerciseType,
        'durationSeconds': durationSeconds,
      };
}

class PracticeRepository {
  final Dio _dio;
  PracticeRepository(this._dio);

  Future<void> submitSession(List<PracticeResult> results) async {
    try {
      await _dio.post(
        '/practice/submit',
        data: results.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      throw Exception('Failed to submit practice: $e');
    }
  }
}

final practiceRepositoryProvider = FutureProvider<PracticeRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return PracticeRepository(dio);
});