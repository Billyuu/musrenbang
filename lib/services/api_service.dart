import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.0.102/api_musrenbang/public/api";

  // LOGIN
  static Future<Map<String, dynamic>> login({
    required String nik,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"nik": nik, "password": password}),
    );

    print('ini body nya ${jsonEncode({"nik": nik, "password": password})}');

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }

  // REGISTER
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String nik,
    required String alamat,
    required String jenisKelamin,
    required String nomorTelepon,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "nama": nama,
        "nik": nik,
        "alamat": alamat,
        "jenis_kelamin": jenisKelamin,
        "nomor_telepon": nomorTelepon,
        "password": password,
      }),
    );

    print("REGISTER STATUS: ${response.statusCode}");
    print("REGISTER BODY: ${response.body}");

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }

  // GET USERS
  static Future<List<dynamic>> getUsers() async {
    final url = Uri.parse("$baseUrl/users");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}
