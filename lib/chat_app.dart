import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lab40/helpers/request.dart';
import 'package:lab40/models/message.dart';
import 'package:lab40/theme/colors.dart';
import 'package:lab40/screens/chat_screen.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  List<Message> messages = [];
  var loginController = TextEditingController();
  final scrollController = ScrollController();
  bool isFetching = false;
  String? fetchError;
  String loginText = '';

  void fetchMessages() async {
    setState(() {
      isFetching = true;
      fetchError = null;
    });
    try {
      final List<dynamic> messagesData = await requestGet(
        'http://146.185.154.90:8000/messages',
      );
      setState(() {
        messages = messagesData.map((m) => Message.fromJson(m)).toList();
        isFetching = false;
      });
      messageList();
      scroll();
    } catch (e) {
      setState(() {
        isFetching = false;
        fetchError = e.toString();
      });
    }
  }

  void scroll() {
    Timer(Duration(milliseconds: 600), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  void messageList() {
    if (fetchError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (ctx) => ChatWidget(
                messages: messages,
                controller: scrollController,
                fetchMessages: fetchMessages,
                login: loginText,
                scroll: scroll,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColor = Theme.of(context).extension<CustomColor>()!;
    Widget content;
    !isFetching
        ? content = Container(
          color: customColor.screenBackgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter your login:',
                  style: TextStyle(
                    fontSize: 30,
                    color: customColor.cardBackgroundColor,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: loginController,
                  onChanged: (value) {
                    setState(() {
                      loginText = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Login',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed:
                      loginText.isNotEmpty
                          ? () {
                            fetchMessages();
                          }
                          : null,
                  child: Text('Login', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        )
        : content = Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: Text('Authorization Step')),
      body: content,
    );
  }
}
