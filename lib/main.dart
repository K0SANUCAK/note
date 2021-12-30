import 'package:flutter/material.dart';
import 'package:note_keeper_app/ui/home_screen_ui.dart';

void main() {
  runApp(const MaterialApp(
    title: "Note App",
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
  ));
}
