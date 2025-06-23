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
    required String city,
  }) async {
    final result = await _authService.registerStep2(
      userPhone: userPhone,
      city: city,
    );

    if (result['success']) {
      await _loadUserSession(); // تحديث بيانات المستخدم بعد إضافة البيانات الإضافية
    }

    return result;
  }

  // تحديث بيانات مكتب العقارات - الخطوة الثانية
  Future<Map<String, dynamic>> registerRealstateOfficeStep2({
    required String phone,
    required String city,
    required String address,
    required int officeLogo,
    required int ownerIdFront,
    required int ownerIdBack,
    required int officeImage,
    required int commercialCardFront,
    required int commercialCardBack,
    required bool vat,
  }) async {
    final result = await _authService.registerRealstateOfficeStep2(
      phone: phone,
      address: address,
      officeLogo: officeLogo,
      ownerIdFront: ownerIdFront,
      ownerIdBack: ownerIdBack,
      officeImage: officeImage,
      commercialCardFront: commercialCardFront,
      commercialCardBack: commercialCardBack,
      vat: vat,
      city: city,
    );

    if (result['success']) {
      await _loadUserSession();
    }

    return result;
  }

  // تحديث البيانات النصية فقط لحساب مكتب العقار
  Future<Map<String, dynamic>> updateRealstateOfficeDetails({
    required String phone,
    required String city,
    required String address,
    required bool vat,
  }) async {
    final result = await _authService.updateRealstateOfficeDetails(
      phone: phone,
      city: city,
      address: address,
      vat: vat,
    );

    if (result['success']) {
      await _loadUserSession();
    }

    return result;
  }

  // ربط معرفات الوسائط بحساب المكتب
  Future<Map<String, dynamic>> updateRealstateOfficeMedia({
    int? officeLogo,
    int? ownerIdFront,
    int? ownerIdBack,
    int? officeImage,
    int? commercialCardFront,
    int? commercialCardBack,
  }) async {
    final result = await _authService.updateRealstateOfficeMedia(
      officeLogo: officeLogo,
      ownerIdFront: ownerIdFront,
      ownerIdBack: ownerIdBack,
      officeImage: officeImage,
      commercialCardFront: commercialCardFront,
      commercialCardBack: commercialCardBack,
    );

    if (result['success']) {
      await _loadUserSession();
    }

    return result;
  }

  // إنشاء حساب مكتب عقار كامل بالخطوات المتتالية
  Future<Map<String, dynamic>> registerRealstateOffice({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String city,
    required String address,
    bool vat = false,
    String? officeLogoPath,
    String? ownerIdFrontPath,
    String? ownerIdBackPath,
    String? officeImagePath,
    String? commercialCardFrontPath,
    String? commercialCardBackPath,
  }) async {
    final result = await _authService.registerRealstateOffice(
      username: username,
      email: email,
      password: password,
      phone: phone,
      city: city,
      address: address,
      vat: vat,
      officeLogoPath: officeLogoPath,
      ownerIdFrontPath: ownerIdFrontPath,
      ownerIdBackPath: ownerIdBackPath,
      officeImagePath: officeImagePath,
      commercialCardFrontPath: commercialCardFrontPath,
      commercialCardBackPath: commercialCardBackPath,
    );

    if (result['success']) {
      await _loadUserSession();
    }

    return result;
  }

  // تسجيل مستخدم جديد وإنشاء app user مباشرة
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String userPhone,
    required String city,
  }) async {
    final result = await _authService.registerUser(
      username: username,
      email: email,
      password: password,
      userPhone: userPhone,
      city: city,
    );

    if (result['success']) {
      await _loadUserSession();
    }

    return result;
  }

  // تحديث المدينة الحالية
  Future<Map<String, dynamic>> updateCity(String city) async {
    final result = await _authService.updateCity(city);
    if (result['success']) {
      await _loadUserSession();
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