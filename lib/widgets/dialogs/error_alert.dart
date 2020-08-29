import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String _errorMessage;
  final String _traceString;

  ErrorAlert({String errorMessage, String traceString})
      : _errorMessage = errorMessage,
        _traceString = traceString;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Dammit!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Looks like there was A problem.'),
            SizedBox(height: 20),
            Text('error: $_errorMessage'),
            SizedBox(height: 20),
            Text(_traceString),
            // RichText(
            //   text: TextSpan(
            //     text: problem.traceString,
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
            //   ),
            // )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop<dynamic>();
          },
        ),
      ],
    );
  }
}
