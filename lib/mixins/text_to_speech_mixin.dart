import 'dart:io';


import 'package:flutter_tts/flutter_tts.dart';

mixin TextToSpeechMixin {
  FlutterTts flutterTts = FlutterTts();

  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.2;

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;

  bool isPlaying = false;

  Future<void> togglePlaying(String text) async {
    if (isPlaying) {
      _stop();
      return;
    }
    _speak(text);
  }

  Future<dynamic> disposeTts() async {
    await flutterTts.stop();
  }

  Future<void> initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage('ja-JP');

    if (isIOS) {
      await flutterTts.setSharedInstance(true);
    }

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setCompletionHandler(() {
      // setState(() {
      //   isPlaying = false;
      // });
    });
  }

  Future _speak(String text) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(0);
    // await flutterTts.setPitch(pitch);
    var result = await flutterTts.speak(text);
    print('RESULT: $result');
    // if (result == 1 && mounted) setState(() => isPlaying = true);
  }

  Future _stop() async {
    var result = await disposeTts();
    // if (result == 1) setState(() => isPlaying = false);
  }

  Future _getDefaultEngine() async {
    final engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    final voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  @override
  void dispose() {
    // super.dispose();
    disposeTts();
  }
}
