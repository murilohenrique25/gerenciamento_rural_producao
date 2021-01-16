import 'dart:ui';

import 'package:flutter/material.dart';

class ListarAnimais extends StatefulWidget {
  @override
  _ListarAnimaisState createState() => _ListarAnimaisState();
}

class _ListarAnimaisState extends State<ListarAnimais> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/listar.jpg",
                  height: 150.0,
                  width: 150.0,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  colorBlendMode: BlendMode.modulate,
                ),
                Text(
                  "Listar Animais",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
