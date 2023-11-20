import 'dart:convert';

import 'package:flutter/material.dart';

Future push(BuildContext context, Widget page) {
  return Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }));
}

String utf8convert(String text) {
List<int> bytes = text.toString().codeUnits;
return utf8.decode(bytes);
}