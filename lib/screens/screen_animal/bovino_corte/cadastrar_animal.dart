import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/cadastro.dart';

class CadastrarAnimal extends StatefulWidget {
  @override
  _CadastrarAnimalState createState() => _CadastrarAnimalState();
}

class _CadastrarAnimalState extends State<CadastrarAnimal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Cadastro()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/add.jpg",
                  height: 150.0,
                  width: 150.0,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  colorBlendMode: BlendMode.modulate,
                ),
                Text(
                  "Cadastrar Animal",
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
