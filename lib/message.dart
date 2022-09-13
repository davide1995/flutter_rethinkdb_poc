class Message {
  final String text;
  final String nickname;
  final DateTime dateTime;

  Message(this.text, this.nickname, this.dateTime);

  static Message fromMap(Map<String, dynamic> map) {
    return Message(map['text'], map['nickname'], map['dateTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'nickname': nickname,
      'dateTime': dateTime
    };
  }
}
