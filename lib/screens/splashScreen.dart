import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            ),
            Text("Welcome To Online Shop"),
          ],
        ),
      ),
    );
  }
}
