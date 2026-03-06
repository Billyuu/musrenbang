import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('http://127.0.0.1:8000/api/login');
  final body = jsonEncode({"nik": "3578123456789001", "password": "123456"});
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );

    print(
      'statuscode: ${response.statusCode}\ndata: ${jsonDecode(response.body)}',
    );
  } catch (e) {
    print(e.toString());
  }
}
