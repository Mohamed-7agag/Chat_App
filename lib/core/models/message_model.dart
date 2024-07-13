import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String? message;
  final String? fromId;
  final String? toId;
  final String? sendAt;
  final String? readAt;
  final String? type;

  const MessageModel({
    this.message,
    this.fromId,
    this.toId,
    this.sendAt,
    this.readAt,
    this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        message: json['message'] as String?,
        fromId: json['fromID'] as String?,
        toId: json['toID'] as String?,
        sendAt: json['sendAt'] as String?,
        readAt: json['readAt'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'fromID': fromId,
        'toID': toId,
        'sendAt': sendAt,
        'readAt': readAt,
        'type': type,
      };

  @override
  List<Object?> get props {
    return [
      message,
      fromId,
      toId,
      sendAt,
      readAt,
      type,
    ];
  }
}
