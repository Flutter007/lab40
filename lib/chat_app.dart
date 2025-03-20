import 'package:flutter/material.dart';
import 'package:lab40/helpers/request.dart';
import 'package:lab40/models/message.dart';
import 'package:lab40/widgets/chat_widget.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  List<Message> messages = [];
  var loginController = TextEditingController();
  bool isFetching = true;
  bool ifFetchError = false;

  void fetchMessages() async {
    setState(() {
      isFetching = true;
      ifFetchError = false;
    });
    try {
      final List<dynamic> messagesData = await requestGet(
        'http://146.185.154.90:8000/messages',
      );

      setState(() {
        messageList();
        messages = messagesData.map((m) => Message.fromJson(m)).toList();
        isFetching = false;
      });
    } catch (e) {
      //
    }
  }

  void messageList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (ctx) => ChatWidget(
              isFetching: isFetching,
              ifFetchError: ifFetchError,
              messages: messages,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authorization Step')),
      body: Center(
        child: Column(
          children: [
            Text('Enter your login:'),
            SizedBox(height: 20),
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                labelText: 'Login',
                border: OutlineInputBorder(),
              ),
            ),
            TextButton(
              onPressed: () {
                fetchMessages();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
