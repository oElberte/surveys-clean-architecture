import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String error) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).errorColor,
      content: Text(error, textAlign: TextAlign.center),
    ),
  );
}
