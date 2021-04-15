import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/tree_screen/plantel/list_eguas.dart';

class EguaScreen extends StatefulWidget {
  @override
  _EguaScreenState createState() => _EguaScreenState();
}

class _EguaScreenState extends State<EguaScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListaEguas()));
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
                      // Icon(
                      //   Icons.add,
                      //   size: 21.0,
                      // ),
                      Text(
                        "Éguas",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.5,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
