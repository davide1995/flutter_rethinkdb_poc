import 'package:flutter/material.dart';

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

  insertNameDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please identify yourself'),
      content: TextField(
        decoration: const InputDecoration(hintText: "Your nickname"),
        onChanged: (value) {
          setState(() {
            nickname = value;
          });
        }
      ),
      actions: [
        TextButton(
          child: const Text('Done'),
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    );
  }

  sendMessage() {

  }

  @override
  void initState() {
    super.initState();
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
                child: Text("Hello $nickname")
            )
          ),
          const Expanded(
            flex: 8,
            child:  Placeholder(),
          ),
          Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    const Expanded(
                        flex: 9,
                        child: TextField(
                            decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                hintText: "Your message"
                            )
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
                /*child: TextField(decoration: InputDecoration(border: OutlineInputBorder()))*/
            )
          )
        ]
      )
    );
  }
}
