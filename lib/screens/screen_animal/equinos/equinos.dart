import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/description_equinos.dart';

class Equinos extends StatefulWidget {
  @override
  _EquinosState createState() => _EquinosState();
}

class _EquinosState extends State<Equinos> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DescriptionEquinos()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "images/equinos.jpg",
                    height: 150.0,
                    width: 150.0,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    colorBlendMode: BlendMode.modulate,
                  ),
                  Text(
                    "Equinos",
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1.0,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
