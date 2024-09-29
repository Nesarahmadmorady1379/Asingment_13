import 'package:flutter/material.dart';
import 'package:notapp/screens/adding_userpage.dart';
import 'package:notapp/screens/login.dart';
import 'package:notapp/screens/saveddata.dart';
import 'package:notapp/screens/splashScreen.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => splashscreen(),
      '/login': (context) => login(),
      '/addinguser': (context) => AddingUserPage(),
      '/userdata': (context) => SavedDataPage(),
    },
  ));
}
