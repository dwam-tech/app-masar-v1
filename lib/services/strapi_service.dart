import 'dart:convert';
import 'package:http/http.dart' as http;

class StrapiService {
  static const String baseUrl = 'http://192.168.1.12:1337';

  /// Uploads a file to Strapi and returns the media ID when successful.
  Future<int?> uploadMedia(String filePath, String token) async {
    final uri = Uri.parse('$baseUrl/api/upload');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('files', filePath));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      if (data is List && data.isNotEmpty) {
        return data[0]['id'] as int?;
      }
    }
    return null;
  }
}
