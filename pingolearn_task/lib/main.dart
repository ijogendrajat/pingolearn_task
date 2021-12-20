import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pingolearn Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  stt.SpeechToText _speech;
  String _text = "Say Something here";
  bool _isListening = false;
  // String _currentLocaleId = '';

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          // localeId: "en-US",
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PingoLearn Task"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_text),
            Card(
              elevation: 10,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Column(children: [
                  Text(
                    "Your word",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 10,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Column(children: [
                  Text(
                    "Meaning",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 10,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Column(children: [
                  Text(
                    "Example",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _text,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              elevation: 10,
              child: Container(
                height: 200,
                width: 200,
                child: Column(children: [
                  Text(
                    "Photo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.blue,
        duration: const Duration(milliseconds: 200),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        endRadius: 80,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
