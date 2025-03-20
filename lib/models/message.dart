class Message {
  final String id;
  final String author;
  final String message;
  final DateTime dateTime;

  Message({
    required this.id,
    required this.author,
    required this.message,
    required this.dateTime,
  });
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      author: json['author'],
      message: json['message'],
      dateTime: DateTime.parse(json['datetime']).toLocal(),
    );
  }
}
