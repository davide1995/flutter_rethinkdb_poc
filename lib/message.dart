class Message {
  final String text;
  final String nickname;
  final DateTime dateTime;

  Message(this.text, this.nickname, this.dateTime);

  /*Message.fromJson(Map<String, dynamic> json) :
        text = json['text'], nickname = json['nickname'], dateTime = json['dateTime'];*/
}
