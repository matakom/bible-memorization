import 'package:dio/dio.dart';
import 'package:flutter_app/providers/core/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus { unknown, online, serverDown, offline }

class ConnectionNotifier extends Notifier<ConnectionStatus> {
  DateTime? _lastCheck;

  @override
  ConnectionStatus build() {
    return ConnectionStatus.unknown;
  }

  Future<void> checkConnection({bool isSilent = false}) async {
    if (_lastCheck != null && 
        DateTime.now().difference(_lastCheck!) < const Duration(seconds: 10)) {
      return;
    }

    if (!isSilent || state == ConnectionStatus.unknown) {
      state = ConnectionStatus.unknown;
    }

    _lastCheck = DateTime.now();

    try {
      final dio = await ref.read(dioProvider.future);
      await dio.get('/health', options: Options(extra: {'skipAuth': true}));
      
      if (state != ConnectionStatus.online) {
        state = ConnectionStatus.online;
      }
    } on DioException catch (e) {
      final newStatus = (e.response?.statusCode == 530 || (e.response?.statusCode ?? 0) >= 500)
          ? ConnectionStatus.serverDown
          : ConnectionStatus.offline;
      
      if (state != newStatus) state = newStatus;
    } catch (_) {
      if (state != ConnectionStatus.offline) state = ConnectionStatus.offline;
    }
  }

  Future<void> retry() async {
    _lastCheck = null; 
    await checkConnection(isSilent: false);
  }
}

final connectionProvider = NotifierProvider<ConnectionNotifier, ConnectionStatus>(
  ConnectionNotifier.new,
);