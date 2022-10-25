import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations string = EnUs();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        string = EnUs();
        break;
    }
  }
}
