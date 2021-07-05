import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/rebanho/plantel/second_screen/list_garrotes_corte%20copy.dart';

class TouroCorteScreen extends StatefulWidget {
  @override
  _TouroScreenState createState() => _TouroScreenState();
}

class _TouroScreenState extends State<TouroCorteScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListaTourosCorte()),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/fundocinza.jpg",
                  height: 150.0,
                  width: 150.0,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  colorBlendMode: BlendMode.modulate,
                ),
                Container(
                  height: 20.0,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        "Touro",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.5,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}