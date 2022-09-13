import 'package:flutter/material.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'package:flutter_rethinkdb_poc/message.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter RethinkDb PoC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(title: 'Chat'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var nickname = "";
  final currentMessageController = TextEditingController();

  DB db = RethinkDb().db("flutter_rethinkdb_poc");
  Connection? connection;

  final _biggerFont = const TextStyle(fontSize: 18);
  final conversation = <Message>[];

  insertNameDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please identify yourself'),
      content: TextField(
        decoration: const InputDecoration(hintText: "Your nickname"),
        onSubmitted: (_) => Navigator.of(context).pop(),
        onChanged: (value) => setState(() => nickname = value)
      ),
      actions: [
        TextButton(
          child: const Text('Done'),
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    );
  }

  Future<void> sendMessage() async {
    final message = Message(currentMessageController.value.text, nickname, DateTime.now());
    db.table('conversation').insert(message.toMap()).run(connection!);
    setState(() => currentMessageController.clear());
  }

  void fetchMessages() {
    db.table('conversation').orderBy('dateTime').run(connection!).then((conversationDb) =>
        conversationDb.forEach((messageDb) => setState(() =>
            conversation.add(Message.fromMap(messageDb)))));
  }

  void listenMessages() {
    db.table('conversation').changes().run(connection!).then((value) {
      (value as Feed).forEach((element) {
        final messageDb = element["new_val"];
        setState(() => conversation.add(Message.fromMap(messageDb)));
      });
    });
  }

  @override
  void initState() {
    super.initState();

    RethinkDb().connect(host: '192.168.248.162', port: 28015).then((value) {
      connection = value;
      fetchMessages();
      listenMessages();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        showDialog(context: context, builder: (_) => insertNameDialog(context)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.center,
                child: Text("Welcome back $nickname", style: _biggerFont)
            )
          ),
          Expanded(
            flex: 8,
            child: ListView(
              children: conversation.map((message) =>
              Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(8),
                color: Color(message.nickname.hashCode).withOpacity(1.0),
                child: Text("${message.nickname == nickname ? "You" : message.nickname}: ${message.text}"),
              )).toList())
          ),
          Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                        flex: 9,
                        child: TextField(
                            decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                hintText: "Your message",
                            ),
                            onSubmitted: (_) => sendMessage(),
                            textInputAction: TextInputAction.go,
                            controller: currentMessageController
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: TextButton(
                          child: const Text('Send'),
                          onPressed: () => sendMessage()
                        )
                    )
                  ],
                )
            )
          )
        ]
      )
    );
  }
}
