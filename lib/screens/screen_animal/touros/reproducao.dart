import 'package:flutter/material.dart';

class Reproducao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reprodução"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 150.0,
          height: 150.0,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}
