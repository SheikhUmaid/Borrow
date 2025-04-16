class TransactionModel {
  final int id;
  final String sender;
  final int senderId;
  final String receiver;
  final int receiverId;
  final double amount;
  final DateTime date;
  final String status;
  final String note;
  final String type;

  TransactionModel({
    required this.id,
    required this.sender,
    required this.senderId,
    required this.receiver,
    required this.receiverId,
    required this.amount,
    required this.date,
    required this.status,
    required this.note,
    required this.type,
  });

  // Convert JSON to TransactionModel
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      sender: json['sender'],
      senderId: json['sender_id'],
      receiver: json['receiver'],
      receiverId: json['receiver_id'],
      amount: (json['amount'] as num).toDouble(), // Ensure double conversion
      date: DateTime.parse(json['date']),
      status: json['status'],
      note: json['note'] ?? '',
      type: json['type'],
    );
  }

  // Convert TransactionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'sender_id': senderId,
      'receiver': receiver,
      'receiver_id': receiverId,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'note': note,
      'type': type,
    };
  }
}
