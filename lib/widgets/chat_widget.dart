import 'package:flutter/material.dart';
import '../helpers/formatted_datetime.dart';
import '../models/message.dart';

class ChatWidget extends StatelessWidget {
  final List<Message> messages;
  final bool isFetching;
  final bool ifFetchError;

  const ChatWidget({
    super.key,
    required this.messages,
    required this.isFetching,
    required this.ifFetchError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String title;
    Widget content;
    if (isFetching) {
      title = 'Loading ...';
      content = Center(child: CircularProgressIndicator());
    } else if (ifFetchError) {
      title = 'Error';
      content = Center(child: Text('Error while catching post!'));
    } else {
      content = ListView.builder(
        itemCount: messages.length,
        itemBuilder:
            (ctx, index) => Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ${messages[index].author} said'),
                    SizedBox(height: 10),
                    Text('Message: ${messages[index].message}'),
                    SizedBox(height: 10),
                    Text(' ${formattedDateTime(messages[index].dateTime)}'),
                  ],
                ),
              ),
            ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: content,
    );
  }
}
