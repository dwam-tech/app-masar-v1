import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // عنوان الخادم الخاص بواجهة برمجة التطبيقات
  static const String baseUrl = 'http://192.168.1.12:1337';
  // API token with elevated permissions used before user login
  static const String adminApiToken =
      '93474d3881c0274f78c97c281d3a178cfbb139fe90794f42f4ae45bf7aae5f6f0277050f1e27dcc841a35fe14fb14a9fc6ce35a4528fa0738767a6f5233cdaecf2c23b088cdb891316218a6af07a8cafb2b57f4cbdcc9e18bec5b959537b40e91541df94696c7183ebf30981ae209a78b27c2f55d283064cca8097ab774b2c2b';
  static const String loginEndpoint = '/api/auth/local';
  static const String registerEndpoint = '/api/auth/local/register';
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String userTypeKey = 'user_type';

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
    required String userPhone,
    required String city,
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

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'type': 'user',
          'userPhone': userPhone,
          'city': city
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _updateUserData(responseData);
        return {
          'success': true,
          'data': responseData,
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

  // تحديث بيانات حساب مكتب عقاري وربط صور المكتب مباشرة بالمستخدم
  Future<Map<String, dynamic>> registerRealstateOfficeStep2({
    required String phone,
    required String city,
    required String address,
    int? officeLogo,
    int? ownerIdFront,
    int? ownerIdBack,
    int? officeImage,
    int? commercialCardFront,
    int? commercialCardBack,
    required bool vat,
  }) async {
    try {
      final userData = await getUserData();
      if (userData == null) {
        return {
          'success': false,
          'message': 'بيانات المستخدم غير متوفرة',
        };
      }

      final userId = userData['id'];

      // تحديث بيانات المستخدم مباشرة دون إنشاء سجل منفصل
      final updateResponse = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $adminApiToken',
        },
        body: jsonEncode({
          'type': 'RealstateOffice',
          'phone': phone,
          'city': city,
          'RealstateOfficeAddress': address,
          'RealstateOfficeLogo': officeLogo,
          'RealstateOfficeOwnerIdFront': ownerIdFront,
          'RealstateOfficeOwnerIdBack': ownerIdBack,
          'RealstateOfficeImage': officeImage,
          'RealstateOfficeCommercialCardFront': commercialCardFront,
          'RealstateOfficeCommercialCardBack': commercialCardBack,
          'Vat': vat,
        }),
      );

      final updateData = jsonDecode(updateResponse.body);

      if (updateResponse.statusCode == 200) {
        final userToken = await getToken();
        Map<String, dynamic> refreshed = updateData;
        if (userToken != null) {
          // Fetch the latest user info so newly linked media are included
          final fetchResponse = await http.get(
            Uri.parse('$baseUrl/api/users/me?populate=*'),
            headers: {
              'Authorization': 'Bearer $userToken',
            },
          );
          if (fetchResponse.statusCode == 200) {
            refreshed = jsonDecode(fetchResponse.body);
          }
        }

        await _updateUserData(updateData);
        return {
          'success': true,
          'data': updateData,
        };
      } else {
        return {
          'success': false,
          'message': updateData['error']?['message'] ?? 'فشل تحديث بيانات المستخدم',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال بالخادم: $e',
      };
    }
  }

  /// الخطوة الثانية: تحديث الحقول النصية فقط لحساب مكتب العقار
  Future<Map<String, dynamic>> updateRealstateOfficeDetails({
    required String phone,
    required String city,
    required String address,
    required bool vat,
  }) async {
    try {
      final userData = await getUserData();
      if (userData == null) {
        return {
          'success': false,
          'message': 'بيانات المستخدم غير متوفرة',
        };
      }

      final userId = userData['id'];

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $adminApiToken',
        },
        body: jsonEncode({
          'type': 'RealstateOffice',
          'phone': phone,
          'city': city,
          'RealstateOfficeAddress': address,
          'Vat': vat,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await _updateUserData(data);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['error']?['message'] ?? 'فشل تحديث البيانات النصية',
        };
      }
    } catch (e) {
      print('خطأ في تحديث البيانات النصية: $e');
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم: $e'};
    }
  }

  /// الخطوة الرابعة: ربط الوسائط المرفوعة بحساب مكتب العقار
  Future<Map<String, dynamic>> updateRealstateOfficeMedia({
    int? officeLogo,
    int? ownerIdFront,
    int? ownerIdBack,
    int? officeImage,
    int? commercialCardFront,
    int? commercialCardBack,
  }) async {
    try {
      final userData = await getUserData();
      if (userData == null) {
        return {
          'success': false,
          'message': 'بيانات المستخدم غير متوفرة',
        };
      }

      final userId = userData['id'];
      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $adminApiToken',
        },
        body: jsonEncode({
          'RealstateOfficeLogo': officeLogo,
          'RealstateOfficeOwnerIdFront': ownerIdFront,
          'RealstateOfficeOwnerIdBack': ownerIdBack,
          'RealstateOfficeImage': officeImage,
          'RealstateOfficeCommercialCardFront': commercialCardFront,
          'RealstateOfficeCommercialCardBack': commercialCardBack,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await _updateUserData(data);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': data['error']?['message'] ?? 'فشل ربط الوسائط بالمستخدم',
        };
      }
    } catch (e) {
      print('خطأ في تحديث الوسائط: $e');
      return {'success': false, 'message': 'خطأ في الاتصال بالخادم: $e'};
    }
  }

  // تسجيل مكتب عقاري متكامل مع رفع الملفات وربطها بالمستخدم مباشرة
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
    int? officeLogoId;
    int? ownerIdFrontId;
    int? ownerIdBackId;
    int? officeImageId;
    int? crFrontId;
    int? crBackId;

    try {
      // ارفع الملفات المطلوبة أولاً
      officeLogoId = await _uploadFile(officeLogoPath);
      if (officeLogoPath != null && officeLogoId == null) {
        throw Exception('فشل رفع شعار المكتب');
      }

      ownerIdFrontId = await _uploadFile(ownerIdFrontPath);
      if (ownerIdFrontPath != null && ownerIdFrontId == null) {
        throw Exception('فشل رفع هوية المالك الأمامية');
      }

      ownerIdBackId = await _uploadFile(ownerIdBackPath);
      if (ownerIdBackPath != null && ownerIdBackId == null) {
        throw Exception('فشل رفع هوية المالك الخلفية');
      }

      officeImageId = await _uploadFile(officeImagePath);
      if (officeImagePath != null && officeImageId == null) {
        throw Exception('فشل رفع صورة المكتب');
      }

      crFrontId = await _uploadFile(commercialCardFrontPath);
      if (commercialCardFrontPath != null && crFrontId == null) {
        throw Exception('فشل رفع السجل التجاري الأمامي');
      }

      crBackId = await _uploadFile(commercialCardBackPath);
      if (commercialCardBackPath != null && crBackId == null) {
        throw Exception('فشل رفع السجل التجاري الخلفي');
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في رفع الملفات: $e',
      };
    }

    // بعد رفع الملفات بنجاح، أنشئ الحساب
    final step1 = await registerStep1(
      username: username,
      email: email,
      password: password,
    );

    if (!step1['success']) return step1;

    final token = await getToken();
    final userData = await getUserData();
    if (token == null || userData == null) {
      return {
        'success': false,
        'message': 'فشل إنشاء الجلسة بعد التسجيل',
      };
    }

    final userId = userData['id'];

    try {
      // أرسل جميع المعرفات في طلب واحد لتحديث المستخدم
      final updateResponse = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $adminApiToken',
        },
        body: jsonEncode({
          'type': 'RealstateOffice',
          'phone': phone,
          'city': city,
          'RealstateOfficeAddress': address,
          'RealstateOfficeLogo': officeLogoId,
          'RealstateOfficeOwnerIdFront': ownerIdFrontId,
          'RealstateOfficeOwnerIdBack': ownerIdBackId,
          'RealstateOfficeImage': officeImageId,
          'RealstateOfficeCommercialCardFront': crFrontId,
          'RealstateOfficeCommercialCardBack': crBackId,
          'Vat': vat,
        }),
      );

      final updateData = jsonDecode(updateResponse.body);

      if (updateResponse.statusCode == 200) {
        await _updateUserData(updateData);
        return {
          'success': true,
          'data': updateData,
        };
      } else {
        await _deleteUser(userId, token);
        return {
          'success': false,
          'message': updateData['error']?['message'] ?? 'فشل تحديث بيانات المستخدم',
        };
      }
    } catch (e) {
      await _deleteUser(userId, token);
      return {
        'success': false,
        'message': 'حدث خطأ أثناء إنشاء الحساب: $e',
      };
    }
  }

  // تسجيل مستخدم جديد وإنشاء سجل app user وربطه بالحساب
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String userPhone,
    required String city,
  }) async {
    final step1 = await registerStep1(
      username: username,
      email: email,
      password: password,
    );

    if (!step1['success']) return step1;

    final step2 = await registerStep2(
      userPhone: userPhone,
      city: city,
    );

    return step2;
  }

  // تحديث المدينة بعد التسجيل
  Future<Map<String, dynamic>> updateCity(String city) async {
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

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'city': city}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _updateUserData(responseData);
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'message': responseData['error']?['message'] ?? 'فشل تحديث المدينة',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال بالخادم: $e',
      };
    }
  }

  // تسجيل الدخول
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveUserSession(responseData);
        final userType = responseData['user']?['type'];
        return {
          'success': true,
          'data': responseData,
          'type': userType, // إرجاع نوع المستخدم مباشرة من الحقل
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

  // تحديد نوع المستخدم بناءً على الحقل فقط
  String? _determineUserType(Map<String, dynamic> userData) {
    if (userData.containsKey('type') && userData['type'] is String) {
      return userData['type'] as String;
    }
    return null; // لو مافيش نوع
  }

  // حفظ بيانات جلسة المستخدم
  Future<void> _saveUserSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, data['jwt']);
    await prefs.setString(userDataKey, jsonEncode(data['user']));
    final type = _determineUserType(data['user']);
    if (type != null) {
      await prefs.setString(userTypeKey, type);
    } else {
      await prefs.remove(userTypeKey);
    }
  }

  // تحديث بيانات المستخدم المحلية
  Future<void> _updateUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userDataKey, jsonEncode(userData));
    final type = _determineUserType(userData);
    if (type != null) {
      await prefs.setString(userTypeKey, type);
    } else {
      await prefs.remove(userTypeKey);
    }
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
    final prefs = await SharedPreferences.getInstance();
    final storedType = prefs.getString(userTypeKey);
    if (storedType != null && storedType.isNotEmpty) {
      return storedType;
    }
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

  // التحقق من امتداد الملف المرفوع
  bool _isValidFileType(String path) {
    final allowed = ['jpg', 'jpeg', 'png', 'pdf'];
    final ext = path.split('.').last.toLowerCase();
    return allowed.contains(ext);
  }

  // رفع ملف وإرجاع معرفه
  Future<int?> _uploadFile(String? path, [String? token]) async {
    if (path == null) return null;
    if (!_isValidFileType(path)) {
      throw Exception('نوع ملف غير مدعوم');
    }
    final authToken = token ?? adminApiToken;
    final uri = Uri.parse('$baseUrl/api/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $authToken';

    final mimeType = lookupMimeType(path);
    final file = await http.MultipartFile.fromPath(
      'files',
      path,
      contentType: mimeType != null ? MediaType.parse(mimeType) : null,
    );
    request.files.add(file);

    final response = await request.send();
    final body = await response.stream.bytesToString();
    // Debug log of Strapi response
    print('Upload response: ${response.statusCode} - $body');
    if (response.statusCode == 200) {
      final data = jsonDecode(body);
      if (data is List && data.isNotEmpty) {
        return data[0]['id'] as int?;
      }
    }
    throw Exception('فشل رفع الملف');
  }

  // حذف مستخدم في حال حدوث خطأ
  Future<void> _deleteUser(int userId, String token) async {
    await http.delete(
      Uri.parse('$baseUrl/api/users/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}