import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/api/dio_client.dart';
import 'dart:io';
final dioProvider = FutureProvider<Dio>((ref) async {
  final context = SecurityContext(withTrustedRoots: true);
  return createDioClient(context, ref);
});