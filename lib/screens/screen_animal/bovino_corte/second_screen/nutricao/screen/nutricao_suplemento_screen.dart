import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/nutricao/screen/second_screen/list_nutricao_suplemento.dart';

class NutricaoSuplementoBovinoCorteScreen extends StatefulWidget {
  @override
  _NutricaoSuplementoBovinoCorteScreenState createState() =>
      _NutricaoSuplementoBovinoCorteScreenState();
}

class _NutricaoSuplementoBovinoCorteScreenState
    extends State<NutricaoSuplementoBovinoCorteScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ListNutricaoSuplementoBovinoCorte()));
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
                  height: 35.0,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 21.0,
                      ),
                      Text(
                        "Suplemento\nMineral",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11.5,
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
