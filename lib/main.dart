import 'package:chat_app/chat_app.dart';
import 'package:chat_app/core/initializer.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Initializer.initializeTools();
  runApp(ChatApp());
}
