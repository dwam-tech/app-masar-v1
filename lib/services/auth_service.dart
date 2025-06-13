import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.35:1337';
  static const String loginEndpoint = '/api/auth/local';
  static const String registerEndpoint = '/api/auth/local/register';
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // تسجيل مستخدم جديد - الخطوة الأولى
  Future<Map<String, dynamic>> registerStep1({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveUserSession(responseData);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['error']?['message'] ?? 'فشل إنشاء الحساب',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال بالخادم: $e',
      };
    }
  }

  // إضافة بيانات إضافية لمستخدم نوع user - الخطوة الثانية
  Future<Map<String, dynamic>> registerStep2({
    required String collectionName, // اسم الـ Collection (مثل app-users)
    required Map<String, dynamic> additionalData, // البيانات الإضافية
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'يجب تسجيل الدخول أولاً',
        };
      }

      final userData = await getUserData();
      if (userData == null) {
        return {
          'success': false,
          'message': 'بيانات المستخدم غير متوفرة',
        };
      }

      final userId = userData['id'];
      final response = await http.post(
        Uri.parse('$baseUrl/api/$collectionName'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'data': {
            ...additionalData,
            'users_permissions_user': userId, // ربط المستخدم
          },
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _updateUserData({
          ...userData,
          collectionName: responseData['data'],
        });
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['error']?['message'] ?? 'فشل إنشاء بيانات المستخدم',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال بالخادم: $e',
      };
    }
  }

  // تسجيل الدخول مع جلب العلاقات
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl$loginEndpoint?populate=app_user,realstate_realtor,restaurant_provider,driver_provider,drivers_office_provider'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveUserSession(responseData);
        final userType = _determineUserType(responseData['user']);
        return {
          'success': true,
          'data': responseData,
          'userType': userType, // إرجاع نوع المستخدم
        };
      } else {
        return {
          'success': false,
          'message': responseData['error']?['message'] ?? 'فشل تسجيل الدخول',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال بالخادم: $e',
      };
    }
  }

  // تحديد نوع المستخدم بناءً على العلاقات
  String? _determineUserType(Map<String, dynamic> userData) {
    if (userData['app_user'] != null) return 'user';
    if (userData['realstate_realtor'] != null) return 'realtor';
    if (userData['restaurant_provider'] != null) return 'restaurant';
    if (userData['driver_provider'] != null) return 'driver';
    if (userData['drivers_office_provider'] != null) return 'drivers_office';
    return null; // لو مافيش نوع
  }

  // حفظ بيانات جلسة المستخدم
  Future<void> _saveUserSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, data['jwt']);
    await prefs.setString(userDataKey, jsonEncode(data['user']));
  }

  // تحديث بيانات المستخدم المحلية
  Future<void> _updateUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userDataKey, jsonEncode(userData));
  }

  // الحصول على التوكن
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // الحصول على بيانات المستخدم
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(userDataKey);
    return userDataString != null ? jsonDecode(userDataString) : null;
  }

  // الحصول على نوع المستخدم
  Future<String?> getUserType() async {
    final userData = await getUserData();
    if (userData == null) return null;
    return _determineUserType(userData);
  }

  // التحقق من تسجيل الدخول
  Future<bool> isLoggedIn() async {
    return await getToken() != null;
  }

  // تسجيل الخروج
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userDataKey);
  }
}