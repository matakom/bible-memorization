import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/providers/auth_provider.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio createDioClient(SecurityContext securityContext, Ref ref) {
  final baseUrl = dotenv.env['BASE_URL']; 
  if (baseUrl == null) throw Exception('BASE_URL not found');
  
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
    
  (dio.httpClientAdapter as dynamic).onHttpClientCreate = (HttpClient client) {
    return HttpClient(context: securityContext);
  };

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {

        // Adds auth token
        final authRepo = ref.read(authRepositoryProvider);
        final String? token = await authRepo.getAuthToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        return handler.next(options); 
      },
    ),
  );

  return dio;
}