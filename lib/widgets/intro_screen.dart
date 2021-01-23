import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/home.dart';
import 'package:splashscreen/splashscreen.dart';

Widget introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 2,
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF047D8D),
            Color(0xFF047DC6),
          ],
        ),
        navigateAfterSeconds: Home(),
        loaderColor: Colors.transparent,
      ),
      Center(
        child: Container(
          width: 250,
          height: 250,
          color: Colors.transparent,
          child: Image.asset("images/logo.png"),
        ),
      )
    ],
  );
}
