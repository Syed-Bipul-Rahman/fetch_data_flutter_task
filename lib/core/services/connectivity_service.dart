import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectivityController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast(
      onCancel: () {
        _subscription?.cancel();
        _connectivityController?.close();
        _connectivityController = null;
      },
    );
    _startListening();
    return _connectivityController!.stream;
  }

  void _startListening() {
    if (_subscription != null) return;

    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final isConnected = results.any(
          (result) =>
              result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.ethernet,
        );
        _connectivityController?.add(isConnected);
      },
      onError: (_) {
        _connectivityController?.add(false);
      },
    );
  }

  Future<bool> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet,
      );
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityController?.close();
    _subscription = null;
    _connectivityController = null;
  }
}
