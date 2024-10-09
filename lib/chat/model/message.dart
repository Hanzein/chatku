class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
