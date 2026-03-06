import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

/// Loads and initializes the SSL SecurityContext with trusted certificates.
final sslSecurityContextProvider = FutureProvider<SecurityContext>((ref) async {
  final data = await rootBundle.load('assets/certs/cf_cert.pem');
  final context = SecurityContext(withTrustedRoots: false);
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  return context;
});

/// Provides a configured Dio client for making secure API requests.
final dioProvider = FutureProvider<Dio>((ref) async {
  final securityContext = await ref.watch(sslSecurityContextProvider.future);
  return createDioClient(securityContext, ref);
});