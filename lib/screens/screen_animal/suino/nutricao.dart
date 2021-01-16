import 'dart:ui';

import 'package:flutter/material.dart';

class Nutricao extends StatefulWidget {
  @override
  _NutricaoState createState() => _NutricaoState();
}

class _NutricaoState extends State<Nutricao> {
  String _teste = "False";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_teste == "False") {
                _teste = "True";
              } else {
                _teste = "False";
              }
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              "images/nutricao.jpg",
              height: 150.0,
              width: 150.0,
            ),
          ),
        ),
        Text(
          "Nutrição",
          style: TextStyle(
              color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.bold),
        ),
        Text(_teste),
      ],
    );
  }
}
