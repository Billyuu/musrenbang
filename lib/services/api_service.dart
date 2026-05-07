import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiService {
  static const String baseUrl =
      "http://10.141.221.35/api_musrenbang/public/api";

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

 static Future<String?> getProfileFoto() async {
  try {
    final box = GetStorage();

    print("GET PROFILE USER ID: ${box.read("user_id")}");

    var res = await http.post(
      Uri.parse("$baseUrl/profile"),
      headers: {"Accept": "application/json"},
      body: {
        "user_id": box.read("user_id").toString(),
      },
    );

    print("GET PROFILE BODY: ${res.body}");

    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      return data['data']['foto_url'];
    }
  } catch (e) {
    print("Error getProfileFoto: $e");
  }

  return null;
}

  // Upload Foto Profil (Versi Debug)
  static Future<String?> uploadFoto(File file) async {
    try {
      final box = GetStorage();

      var uri = Uri.parse("$baseUrl/update-foto");
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll({"Accept": "application/json"});

      // 🔥 KIRIM USER ID
      request.fields['user_id'] = box.read("user_id").toString();
      print("UPLOAD USER ID: ${box.read("user_id")}");

      // 🔥 KIRIM FOTO
      request.files.add(await http.MultipartFile.fromPath('foto', file.path));

      var response = await request.send();

      var resBody = await response.stream.bytesToString();

      print("STATUS UPLOAD: ${response.statusCode}");
      print("RESPONSE SERVER: $resBody");

      if (response.statusCode == 200) {
        var data = json.decode(resBody);

        return data['data']['foto_url'];
      }

      return null;
    } catch (e) {
      print("Error upload: $e");
      return null;
    }
  }

  // UPDATE ALAMAT
  static Future<bool> updateAlamat(String alamat) async {
    final box = GetStorage();

    var response = await http.post(
      Uri.parse("$baseUrl/update-alamat"),
      body: {"user_id": box.read("user_id").toString(), "alamat": alamat},
    );

    return response.statusCode == 200;
  }

  // UPDATE NO HP
  static Future<bool> updateNoHp(String noHp) async {
    final box = GetStorage();

    final response = await http.post(
      Uri.parse("$baseUrl/update-nohp"),
      body: {"user_id": box.read("user_id").toString(), "nomor_telepon": noHp},
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    return response.statusCode == 200;
  }

  // SIMPAN USULAN
  static Future<Map<String, dynamic>> simpanUsulan({
    required Map<String, String> data,
    File? foto,
  }) async {
    try {
      // 1. Sesuaikan endpoint dengan yang ada di Laravel
      var uri = Uri.parse("$baseUrl/usulan");
      var request = http.MultipartRequest("POST", uri);

      // 2. Tambahkan header agar server tahu kita mengirim JSON
      request.headers.addAll({"Accept": "application/json"});

      // 3. Masukkan semua data teks (judul, usulan, dll)
      request.fields.addAll(data);

      // 4. Masukkan foto jika ada
      if (foto != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto_usulan', // Pastikan di Laravel namanya juga 'foto'
            foto.path,
          ),
        );
      }

      // 5. Kirim dan terima respon
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // 6. Log untuk mempermudah perbaikan jika masih error
      print("LOG API STATUS: ${response.statusCode}");
      print("LOG API BODY: ${response.body}");

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      print("Error ApiService: $e");
      return {
        "statusCode": 500,
        "body": {"message": "Gagal terhubung ke server"},
      };
    }
  }

  //ambil data usulan
  static Future<Map<String, dynamic>> getUsulan(int userId) async {
    var url = Uri.parse("$baseUrl/usulan/$userId"); // ✅ FIX

    var response = await http.get(url);

    print("GET STATUS: ${response.statusCode}");
    print("GET BODY: ${response.body}");

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }
}
