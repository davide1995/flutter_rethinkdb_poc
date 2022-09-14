class Message {
  String? id;
  String text;
  String nickname;
  DateTime dateTime;

  Message(this.id, this.text, this.nickname, this.dateTime);

  static Message? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Message(map['id'], map['text'], map['nickname'], map['dateTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'nickname': nickname,
      'dateTime': dateTime
    };
  }

  @override
  bool operator == (Object other) =>
      other is Message && id == other.id && text == other.text &&
          nickname == other.nickname && dateTime == other.dateTime;

  @override
  int get hashCode => Object.hash(id, text, nickname, dateTime);
}
