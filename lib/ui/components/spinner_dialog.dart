import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    //User can't click outside the modal until loading ends
    barrierDismissible: false,
    child: SimpleDialog(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(R.string.loading, textAlign: TextAlign.center),
          ],
        ),
      ],
    ),
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
