class ChatEntity {
  final String? creationDate;
  final String? id;
  final Map? memory;
  final String? userUid;
  final bool? selected;
  final bool? lastMessageFailed;
  final List? conversation;

  const ChatEntity({
    this.creationDate,
    this.id,
    this.memory,
    this.userUid,
    this.selected,
    this.lastMessageFailed,
    this.conversation,
  });
}
