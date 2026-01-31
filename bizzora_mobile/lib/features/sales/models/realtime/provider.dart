// lib/providers/revenue_websocket_provider.dart

import 'dart:async';
import 'dart:convert';
import 'package:bizzora_mobile/core/storage_service.dart';
import 'package:bizzora_mobile/features/sales/models/realtime/revenue.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

/// Connection status enum
enum ConnectionStatus { disconnected, connecting, connected, error }

/// Real-time revenue WebSocket provider
/// Handles WebSocket connection internally with Authorization header
class RevenueWebSocketProvider extends ChangeNotifier {
  // ============================================================
  // PRIVATE STATE
  // ============================================================
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;
  RevenueData? _revenueData;
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  String? _errorMessage;
  double? _lastSaleAmount;

  // ============================================================
  // PUBLIC GETTERS
  // ============================================================
  RevenueData? get revenueData => _revenueData;
  ConnectionStatus get connectionStatus => _connectionStatus;
  String? get errorMessage => _errorMessage;
  double? get lastSaleAmount => _lastSaleAmount;

  double get totalRevenue => _revenueData?.totalRevenue ?? 0.0;
  double get todayRevenue => _revenueData?.todayRevenue ?? 0.0;
  int get todaySales => _revenueData?.todaySales ?? 0;
  List<DailyRevenueData> get dailyRevenue => _revenueData?.dailyRevenue ?? [];
  bool get isConnected => _connectionStatus == ConnectionStatus.connected;
  bool get hasData => _revenueData != null;
  String get businessId => _revenueData?.businessId ?? '';

  // ============================================================
  // PUBLIC INIT
  // ============================================================
  /// Initialize provider: fetch token and connect automatically
  Future<void> init() async {
    try {
      _connectionStatus = ConnectionStatus.connecting;
      notifyListeners();

      final token = await StorageService.getToken();
      if (token == null) throw Exception('No token found');

      final serverUrl =
          'wss://nonionizing-lynsey-nonperpetually.ngrok-free.dev/users/admin/ws/revenue';

      await _connect(serverUrl, token);
    } catch (e) {
      _connectionStatus = ConnectionStatus.error;
      _errorMessage = 'Failed to initialize: $e';
      notifyListeners();
    }
  }

  // ============================================================
  // PRIVATE CONNECT
  // ============================================================
  Future<void> _connect(String serverUrl, String token) async {
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(serverUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      _connectionStatus = ConnectionStatus.connected;
      notifyListeners();

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );

      print('[++SUCCESS++] WebSocket connected with token');
    } catch (e) {
      _connectionStatus = ConnectionStatus.error;
      _errorMessage = 'WebSocket connection failed: $e';
      notifyListeners();
    }
  }

  // ============================================================
  // HANDLE MESSAGES
  // ============================================================
  void _handleMessage(dynamic message) {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(message);
      final data = RevenueData.fromJson(jsonData);

      _revenueData = data;

      if (data.isSaleUpdate) {
        _lastSaleAmount = data.saleAmount;
      }

      notifyListeners();
    } catch (e) {
      print('[ERROR] Error parsing message: $e');
    }
  }

  // ============================================================
  // ERROR HANDLING
  // ============================================================
  void _handleError(dynamic error) {
    _connectionStatus = ConnectionStatus.error;
    _errorMessage = 'WebSocket error: $error';
    notifyListeners();
  }

  void _handleDisconnect() {
    _connectionStatus = ConnectionStatus.disconnected;
    notifyListeners();
  }

  // ============================================================
  // RECONNECT
  // ============================================================
  Future<void> reconnect() async {
    try {
      disconnect();
      await Future.delayed(const Duration(seconds: 1));
      await init();
    } catch (e) {
      print('[-] ERROR Reconnect failed: $e');
    }
  }

  // ============================================================
  // DISCONNECT
  // ============================================================
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _connectionStatus = ConnectionStatus.disconnected;
    notifyListeners();
  }

  // ============================================================
  // CLEAR LAST SALE NOTIFICATION
  // ============================================================
  void clearLastSale() {
    _lastSaleAmount = null;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
