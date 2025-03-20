import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> requestGet(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Request Error. Url : $url,code:${response.statusCode}');
  }
}
