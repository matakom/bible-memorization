import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final securityContextFutureProvider = FutureProvider<SecurityContext>((ref) async {
  // Loads SSL certificate
  final data = await rootBundle.load('assets/certs/cf_cert.pem');
  
  final context = SecurityContext(withTrustedRoots: false);
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  
  return context;
});