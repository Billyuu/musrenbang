import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://api.musrenyuk.shop/api/v1/user/profile');
  final body = jsonEncode({"user_id": '2'});
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
