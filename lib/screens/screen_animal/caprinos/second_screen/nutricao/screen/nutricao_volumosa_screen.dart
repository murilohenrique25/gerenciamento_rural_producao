import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/nutricao/screen/second_screen/list_nutricao_volumoso.dart';

class NutricaoVolumosaCaprinoScreen extends StatefulWidget {
  @override
  _NutricaoVolumosaCaprinoScreenState createState() =>
      _NutricaoVolumosaCaprinoScreenState();
}

class _NutricaoVolumosaCaprinoScreenState
    extends State<NutricaoVolumosaCaprinoScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListNutricaoVolumosoCaprino()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/pastagem.jpg",
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
                      Icon(
                        Icons.add,
                        size: 21.0,
                      ),
                      Text(
                        "Volumoso",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.5,
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
