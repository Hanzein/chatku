class Message {
  final String text;
  final String sender;
  final String receiver;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.sender,
    required this.receiver,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': sender,
      'receiver': receiver,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      sender: json['sender'],
      receiver: json['receiver'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
