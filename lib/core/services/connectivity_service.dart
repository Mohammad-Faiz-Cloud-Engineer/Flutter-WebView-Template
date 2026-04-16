import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Checks current connectivity status
  /// Returns false if no connection or if check fails
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      developer.log(
        'Connectivity check failed',
        error: e,
        name: 'ConnectivityService',
      );
      return false; // Return false when check fails to indicate potential connectivity issues
    }
  }

  /// Stream of connectivity changes
  /// Note: This stream should only have a single listener
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  void dispose() {
    // Cleanup if needed
  }
}
