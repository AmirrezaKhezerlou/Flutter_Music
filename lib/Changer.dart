import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Changer extends ChangeNotifier {
  bool is_playing = false;

  void ChangeValue() {
    is_playing = !is_playing;
    notifyListeners();
  }
}


