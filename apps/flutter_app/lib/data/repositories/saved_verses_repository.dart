import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';
import 'package:flutter_app/data/models/saved_verse.dart'; // Import your model

class SavedVersesException implements Exception {
  final String message;
  SavedVersesException(this.message);

  @override
  String toString() => message;
}

class SavedVersesRepository {
  final Dio _dio;

  SavedVersesRepository({required Dio dio}) : _dio = dio;

  /// Fetches all saved verses for the current user
  Future<List<SavedVerse>> getSavedVerses() async {
    try {
      final response = await _dio.get('/saved-verses');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => SavedVerse.fromJson(json)).toList();
    } on DioException catch (e) {
      throw SavedVersesException('Failed to fetch verses: ${e.message}');
    }
  }

  /// Saves a new verse
  Future<List<SavedVerse>> saveVerses(List<VerseCreationPayload> verses) async {
    try {
      final data = verses.map((v) => v.toJson()).toList();
      final response = await _dio.post('/saved-verses', data: data);
      
      // Parse the response (expecting an array of created verses)
      final List<dynamic> responseData = response.data as List<dynamic>;
      return responseData.map((json) => SavedVerse.fromJson(json)).toList();

    } on DioException catch (e) {
      if (e.response != null && e.response?.data['message'] != null) {
        throw SavedVersesException(e.response?.data['message']);
      }
      throw SavedVersesException('Failed to save verses: ${e.message}');
    }
  }

  /// Deletes a verse by its ID
  Future<void> deleteVerse(String id) async {
    try {
      await _dio.delete('/saved-verses/$id');
    } on DioException catch (e) {
      throw SavedVersesException('Failed to delete verse: ${e.message}');
    }
  }
}

final savedVersesRepositoryProvider = FutureProvider<SavedVersesRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return SavedVersesRepository(dio: dio);
});