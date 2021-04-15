import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/nutricao/cadastrar_nutricao.dart';

class NutricaoEquinoScreen extends StatefulWidget {
  @override
  _NutricaoEquinoScreenState createState() => _NutricaoEquinoScreenState();
}

class _NutricaoEquinoScreenState extends State<NutricaoEquinoScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastrarNutricaoEquino()));
            });
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
                Text(
                  "Nutrição",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.5,
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
