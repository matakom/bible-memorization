import 'package:dio/dio.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'package:flutter_app/providers/security_context_provider.dart';
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

  Future<void> sendFriendRequest(String friendCode) async {
    try {
      await _dio.post(
        '/friendships',
        data: {
          'friendCode': friendCode,
        },
      );
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
          throw FriendshipsException('You are already friends or have a pending request.');
        }
      }
      throw FriendshipsException('An unknown error occurred. Please try again.');
    }
  }

}

final friendshipsRepositoryProvider = FutureProvider<FriendshipsRepository>((ref) async {
  final securityContext = await ref.watch(securityContextFutureProvider.future);
  final dio = createDioClient(securityContext, ref);
  return FriendshipsRepository(dio: dio);
});