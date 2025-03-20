import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helpers/formatted_datetime.dart';
import '../helpers/request.dart';
import '../models/message.dart';

class ChatWidget extends StatefulWidget {
  final List<Message> messages;
  final bool isFetching;
  final bool ifFetchError;
  final ScrollController controller;
  final void Function() fetchMessages;
  final String login;

  const ChatWidget({
    super.key,
    required this.messages,
    required this.isFetching,
    required this.ifFetchError,
    required this.controller,
    required this.fetchMessages,
    required this.login,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final messageController = TextEditingController();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 4), (timer) async {
      final lastMessageTime =
          widget.messages.last.dateTime.toUtc().toIso8601String();
      final List<dynamic> messagesData = await requestGet(
        'http://146.185.154.90:8000/messages?datetime=$lastMessageTime',
      );
      print(messagesData);
      if (messagesData.isEmpty) {
        return;
      } else {
        final message = messagesData.map((m) => Message.fromJson(m)).toList();
        setState(() {
          widget.messages.addAll(message);
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    messageController.dispose();
    super.dispose();
  }

  Future<dynamic> requestPost(String url) async {
    final author = widget.login;
    final message = messageController.text;
    await http.post(
      Uri.parse(url),
      body: {'author': author, 'message': message},
    );
  }

  void postSomething() async {
    await requestPost('http://146.185.154.90:8000/messages');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;

    if (widget.isFetching) {
      content = const Center(child: CircularProgressIndicator());
    } else if (widget.ifFetchError) {
      content = const Center(child: Text('Error while catching post!'));
    } else {
      content = SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                controller: widget.controller,
                itemBuilder:
                    (ctx, index) => Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Align(
                        alignment:
                            widget.messages[index].author == widget.login
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                widget.messages[index].author == widget.login
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Text(' ${widget.messages[index].author} said'),
                              const SizedBox(height: 10),
                              Text(
                                'Message: ${widget.messages[index].message}',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ' ${formattedDateTime(widget.messages[index].dateTime)}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: postSomething,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: content,
    );
  }
}
