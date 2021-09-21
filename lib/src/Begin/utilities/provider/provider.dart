import 'package:phoenix/src/Begin/pages/now_playing/now_playing.dart';
import 'package:phoenix/src/Begin/pages/settings/settings.dart';
import 'package:flutter/material.dart';

bool usingSeek = false;

class Leprovider with ChangeNotifier {
  provideman() {
    notifyListeners();
  }

  changeLoop(bool w) {
    loopSelected = w;
    notifyListeners();
  }

  changeShuffle(bool w) {
    shuffleSelected = w;
    notifyListeners();
  }
}

class MrMan with ChangeNotifier {
  int rotate = 0;

  rotator(update) {
    rotate = update;
    if (!breakRotate) {
      notifyListeners();
    }
  }

  rawNotify() {
    notifyListeners();
  }
}

class Seek with ChangeNotifier {
  double time = 00.0;
  incrementTime(double sent) {
    if (!usingSeek) {
      time = sent;
      notifyListeners();
    }
  }

  seekIncrementTime(double sent) {
    time = sent;
    notifyListeners();
  }
}

class Astronautintheocean with ChangeNotifier {
  List searchen = [];
  thesearch(astranau) {
    searchen = astranau;
    notifyListeners();
  }

  rawNotify() {
    notifyListeners();
  }
}
