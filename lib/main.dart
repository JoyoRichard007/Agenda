import 'package:eventcalendar/screens/calendar.dart';
import 'package:eventcalendar/screens/splashScrenn.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));

  // Après un délai de 2 secondes, naviguez vers l'interface principale
  Future.delayed(Duration(seconds: 5), () {
    runApp(MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: CalendarEvent(),
    ));
  });
}
