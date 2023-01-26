import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    id,
    creationDate,
    memory,
    userUid,
    selected,
    lastMessageFailed,
    conversation,
  }) : super(
          id: id,
          creationDate: creationDate,
          memory: memory,
          userUid: userUid,
          selected: selected,
          lastMessageFailed: lastMessageFailed,
          conversation: conversation,
        );

  factory ChatModel.fromSnapshot(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      creationDate: json['creationDate'],
      memory: json['memory'],
      userUid: json['userUid'],
      selected: json['selected'],
      lastMessageFailed: json['lastMessageFailed'],
      conversation: json['conversation'],
    );
  }
}
