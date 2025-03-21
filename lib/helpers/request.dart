import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> requestGet(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Sorry, something went wrong!');
  }
}

Future<dynamic> requestPost(String author, String message) async {
  if (author.isNotEmpty && message.isNotEmpty) {
    await http.post(
      Uri.parse('http://146.185.154.90:8000/messages'),
      body: {'author': author, 'message': message},
    );
  }
}
