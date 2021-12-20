import 'dart:async';
import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  //speech to text part

  stt.SpeechToText _speech;
  String _text = "cow";
  bool _isListening = false;

  //api data
  String url = "https://owlbot.info/api/v4/dictionary/";
  String token = "08a5e3222b8be11a8bdcbaa455cb0f7ab1e7f608";
  Stream _stream;
  StreamController streamController;
  searchText() async {
    if (_text == null || _text.length == 0) {
      streamController.add(null);
      return;
    }
    streamController.add("waiting");
    Response response = await get(url + _text.trim(),
        headers: {"Authorization": "Token " + token});
    streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
    streamController = StreamController();
    _stream = streamController.stream;
  }

  //onpressed function here

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            searchText();
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: Text("PingoLearn Task"),
        centerTitle: true,
      ),
      // body
      body: Container(
        margin: EdgeInsets.all(8),
        child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Press mic button and speak..."),
              );
            }
            if (snapshot.data == "waiting") {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // output
            return ListView.builder(
              itemCount: snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("your speech to text = " + _text),
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
                              "Your word",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _text,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
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
                          padding: EdgeInsets.all(5),
                          height: 100,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Column(children: [
                            Text(
                              "Meaning",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data["definitions"][index]["definition"]
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
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
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _text.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data["definitions"]
                                      [index]["image_url"]
                                  .toString()),
                              fit: BoxFit.fill,
                            ),
                            // shape: BoxShape,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          stream: _stream,
        ),
      ),
      //floating action button
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
