import 'dart:async';
import 'package:flutter/material.dart';
import '../helpers/formatted_datetime.dart';
import '../helpers/request.dart';
import '../models/message.dart';
import '../theme/colors.dart';

class ChatWidget extends StatefulWidget {
  final List<Message> messages;
  final ScrollController controller;
  final void Function() fetchMessages;
  final String login;
  final void Function() scroll;

  const ChatWidget({
    super.key,
    required this.messages,
    required this.controller,
    required this.fetchMessages,
    required this.login,
    required this.scroll,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final messageController = TextEditingController();
  late Timer timer;
  String? ifFetchError;

  @override
  void initState() {
    super.initState();
    try {
      timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        final lastMessageTime =
            widget.messages.last.dateTime.toUtc().toIso8601String();
        final List<dynamic> messagesData = await requestGet(
          'http://146.185.154.90:8000/messages?datetime=$lastMessageTime',
        );
        if (messagesData.isEmpty) {
          return;
        } else {
          final message = messagesData.map((m) => Message.fromJson(m)).toList();
          setState(() {
            widget.messages.addAll(message);
          });
          Future.delayed(Duration(milliseconds: 100), widget.scroll);
        }
      });
    } catch (e) {
      setState(() {
        ifFetchError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    final customColor = Theme.of(context).extension<CustomColor>()!;
    if (ifFetchError != null) {
      content = const Center(child: Text('Error while catching messages!'));
    } else {
      content = Container(
        color: customColor.screenBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.messages.length,
                  controller: widget.controller,
                  itemBuilder: (ctx, index) {
                    bool isSameUser =
                        widget.messages[index].author == widget.login;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Align(
                        alignment:
                            isSameUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          width: 220,
                          decoration: BoxDecoration(
                            color: customColor.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  isSameUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' ${widget.messages[index].author} said',
                                  style: TextStyle(
                                    color: customColor.cardTextColor,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.messages[index].message,
                                  style: TextStyle(
                                    color: customColor.cardTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    ' ${formattedDateTime(widget.messages[index].dateTime)}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onTap: () {
                        setState(() {
                          messageController.text = '';
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        labelText: 'Message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                        () => requestPost(widget.login, messageController.text),
                    icon: Icon(
                      Icons.send,
                      color: customColor.cardBackgroundColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(appBar: AppBar(title: Text('Chat')), body: content);
  }
}
