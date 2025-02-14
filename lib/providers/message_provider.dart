import 'package:flutter/foundation.dart';
import 'package:gaijingo/controllers/kana_controller.dart';

class MessageProvider extends ChangeNotifier {
  MessageProvider(this._kanaControler);

  final KanaControler _kanaControler;

  String get messageTop => _kanaControler.showMessageTop;

  String get messageBottom => _kanaControler.showMessageBottom;

  bool get isTheLastStroke => _kanaControler.isTheLastStroke;

  void updateMessage() {
    // if calling to update message, so all the strokes are drawn
    _kanaControler.updateKana();
    notifyListeners();
  }
}
