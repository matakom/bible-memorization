import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './repository_providers.dart';
import 'package:dio/io.dart';

final sslSecurityContextProvider = FutureProvider<SecurityContext>((ref) async {
  final data = await rootBundle.load('assets/certs/cf_cert.pem');
  final context = SecurityContext(withTrustedRoots: false);
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  return context;
});

final dioProvider = FutureProvider<Dio>((ref) async {
  final securityContext = await ref.watch(sslSecurityContextProvider.future);
  
  final options = BaseOptions(
    baseUrl: 'https://your-nestjs-api.com', 
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  final dio = Dio(options);

  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    return HttpClient(context: securityContext);
  };

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Reads the token from local persistence (works offline if cached)
      final authRepo = ref.read(authRepositoryProvider); 
      final token = await authRepo.getAuthToken();
      
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  return dio;
});