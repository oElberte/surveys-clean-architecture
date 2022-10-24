import 'package:flutter/widgets.dart';

import 'strings/strings.dart';

class R {
  static Translations strings = EnUs();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        strings = EnUs();
        break;
    }
  }
}
