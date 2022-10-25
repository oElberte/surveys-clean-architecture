import 'package:flutter/material.dart';
import 'package:polls/utils/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: null,
      child: Text(R.string.createAccount.toUpperCase()),
    );
  }
}
