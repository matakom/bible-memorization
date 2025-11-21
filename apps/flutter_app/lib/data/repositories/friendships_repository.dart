import 'package:dio/dio.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/core/security_context_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendshipsException implements Exception {
  final String message;
  FriendshipsException(this.message);
  
  @override
  String toString() => message;
}

class FriendshipsRepository {
  final Dio _dio;

  FriendshipsRepository({required Dio dio}) : _dio = dio;

  Future<void> sendFriendshipRequest(String friendCode) async {
    try {
      await _dio.post('/friendships', data: {'friendCode': friendCode});
    } on DioException catch (e) {
      if (e.response != null && e.response?.data['message'] != null) {
        final errorMessage = e.response?.data['message'];

        if (errorMessage == 'User with this friend code not found.') {
          throw FriendshipsException('User not found. Please check the code.');
        }
        if (errorMessage == 'You cannot add yourself as a friend.') {
          throw FriendshipsException('You cannot add yourself.');
        }
        if (errorMessage == 'A friendship or pending request already exists.') {
          throw FriendshipsException('You are already friends or have a pending request.',);
        }
      }
      throw FriendshipsException('An unknown error occurred. Please try again.',);
    }
  }

  Future<List<dynamic>> fetchFriendships() async {
    try {
      final response = await _dio.get('/friendships');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw FriendshipsException('Failed to fetch friendships: ${e.message}');
    }
  }

  Future<void> acceptFriendship(String friendshipId) async {
    try {
      await _dio.patch('/friendships/$friendshipId/accept');
    } on DioException catch (e) {
      throw FriendshipsException('Failed to accept request: ${e.message}');
    }
  }

  Future<void> deleteFriendship(String friendshipId) async{
    try {
      await _dio.delete('/friendships/$friendshipId/delete');
    } on DioException catch (e) {
      throw FriendshipsException('Failed to delete friendship: ${e.message}');
    }
  }
}

final friendshipsRepositoryProvider = FutureProvider<FriendshipsRepository>((
  ref,
) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return FriendshipsRepository(dio: dio);
});
