import 'package:flutter/foundation.dart';
import 'package:saba2v2/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  Map<String, dynamic>? _userData;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;
  String? get token => _token;

  // تهيئة الحالة عند بدء التطبيق
  Future<void> initialize() async {
    await _loadUserSession();
  }

  // تحميل بيانات جلسة المستخدم من التخزين المحلي
  Future<void> _loadUserSession() async {
    _token = await _authService.getToken();
    _userData = await _authService.getUserData();
    _isLoggedIn = _token != null;
    notifyListeners();
  }

  // تسجيل الدخول
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    final result = await _authService.login(identifier: identifier, password: password);

    if (result['success']) {
      await _loadUserSession();
    }

    return result;
  }

  // تسجيل مستخدم جديد - الخطوة الأولى
  Future<Map<String, dynamic>> registerStep1(String username, String email, String password) async {
    final result = await _authService.registerStep1(
      username: username,
      email: email,
      password: password,
    );

    if (result['success']) {
      await _loadUserSession();
    }

    return result;
  }

  // تحديث بيانات المستخدم - الخطوة الثانية
  Future<Map<String, dynamic>> registerStep2({
    required String userPhone,
    required String userCity,
  }) async {
    final result = await _authService.registerStep2(
      userPhone: userPhone,
      userCity: userCity,
    );

    if (result['success']) {
      await _loadUserSession(); // تحديث بيانات المستخدم بعد إضافة البيانات الإضافية
    }

    return result;
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _userData = null;
    _token = null;
    notifyListeners();
  }
}