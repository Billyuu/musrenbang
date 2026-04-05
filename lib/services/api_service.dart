import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://192.168.1.108/api_musrenbang/public/api";

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

  //get foto
  static Future<String?> getProfileFoto() async {
    try {
      var res = await http.get(Uri.parse("$baseUrl/profile"));

      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        return data['data']['foto_url'];
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //foto profil
  static Future<String?> uploadFoto(File file) async {
    try {
      var uri = Uri.parse("$baseUrl/update-foto");

      var request = http.MultipartRequest("POST", uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'foto', // harus sama dengan Laravel
          file.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        var data = json.decode(res);

        return data['data']['foto_url']; // ambil URL
      } else {
        return null;
      }
    } catch (e) {
      print("Error upload: $e");
      return null;
    }
  }

  // UPDATE ALAMAT
  static Future<bool> updateAlamat(String alamat) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update-alamat"),
      body: {"alamat": alamat},
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    return response.statusCode == 200;
  }

  // UPDATE NO HP
  static Future<bool> updateNoHp(String noHp) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update-nohp"),
      body: {"nomor_telepon": noHp},
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    return response.statusCode == 200;
  }
}
