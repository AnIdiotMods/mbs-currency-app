class ChatMessage {
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.body,
    required this.timestamp,
  });

  final String id;
  final String senderId;
  final String recipientId;
  final String body;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'recipientId': recipientId,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
      };
}
