import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Widgets, yo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final GenerativeModel model;
  late final ChatSession chat;
  String chatHistory = '';
  bool chatStarted = false;

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content.text('''
        I'd like to play a poetry guessing game with you. Choose a famous poet,
        and give me their name, plus the name of one of their poems and two
        other famous poems they didn't write. I'll respond by picking one of the
        poem names, and you tell me if it was written by the poet you chose.

        After each round, don't wait for me to say I want to continue. Just
        start a new round.
      '''),
    );

    chat = model.startChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!chatStarted) {
      chatStarted = true;
      chat
          .sendMessage(Content.text('I am ready to play!'))
          .then(
            (response) =>
                setState(() => chatHistory = '${response.text ?? ''}\n\n'),
          );
    }
  }

  Future<void> sendMessage(String msg) async {
    setState(() => chatHistory = '$chatHistory$msg\n\n');
    final response = await chat.sendMessage(Content.text(msg));
    setState(() => chatHistory = '$chatHistory${response.text}\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                  child: Text(chatHistory),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final text = textController.text;
                          textController.clear();
                          await sendMessage(text);
                        },
                        child: Text('Clicky'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
