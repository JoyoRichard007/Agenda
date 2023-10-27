import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE63946),
              Color(0xFFF1FAEE)
            ], // Couleurs de l'arrière-plan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event, // Icône d'événement
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                "AGENDA",
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily:
                      'YourCustomFont', // Utilisez votre propre police de caractères
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
