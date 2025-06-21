import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

final pickAPoem = FunctionDeclaration(
  'pickAPoem',
  'Use this to ask me to pick one poem from a list of three',
  parameters: {
    'poetName': Schema.string(description: 'Name of the chosen poet'),
    'poemList': Schema.array(
      description: 'A list of three poems from which the user can select',
      maxItems: 3,
      minItems: 3,
      items: Schema.string(description: 'The name of a single poem'),
    ),
  },
);

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
        I'd like to play a poetry guessing game with you.
        
        Choose a famous poet, give me their name, and then make a list of three 
        poems: one written by the poet you chose, and two other famous poems
        that were not written by that poet.

        Ask me to pick one poem from that list of three, and then tell me if I
        picked the one written by the poet you chose.

        After each round, don't wait for me to say I want to continue. Just
        start a new round.
      '''),
      tools: [
        Tool.functionDeclarations([
          pickAPoem,
        ]),
      ],
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
            (response) => processResponse(response),
          );
    }
  }

  Future<void> sendMessage(String msg) async {
    setState(() => chatHistory = '$chatHistory$msg\n\n');
    var response = await chat.sendMessage(Content.text(msg));
    await processResponse(response);
  }

  Future<void> processResponse(GenerateContentResponse response) async {
    if (response.text != null) {
      setState(() => chatHistory = '$chatHistory${response.text}\n\n');
    }

    for (final functionCall in response.functionCalls) {
      if (functionCall.name == 'pickAPoem') {
        final poemList = functionCall.args['poemList'] as List<dynamic>;
        final poetName = functionCall.args['poetName'] as String;

        final functionResult = await getPoemChoice(
          context,
          poetName,
          poemList[0] as String,
          poemList[1] as String,
          poemList[2] as String,
        );

        // Send the response to the model so that it can use the result to
        // generate text for the user.
        response = await chat.sendMessage(
          Content.functionResponse(functionCall.name, {
            'poemName': functionResult,
          }),
        );

        processResponse(response);
      }
    }
  }

  Future<String> getPoemChoice(
    BuildContext context,
    String poetName,
    String a,
    String b,
    String c,
  ) async {
    final String? chosenPoem = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Pick a Poem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Which of these poems was written by $poetName?'),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(a),
                child: Text(a),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(b),
                child: Text(b),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(c),
                child: Text(c),
              ),
            ],
          ),
        );
      },
    );
    return chosenPoem ?? '';
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
