import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/description_touro.dart';

class TouroInseminacao extends StatefulWidget {
  @override
  _TouroInseminacaoState createState() => _TouroInseminacaoState();
}

class _TouroInseminacaoState extends State<TouroInseminacao> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DescriptionTouro()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/touro.jpg",
                  height: 150.0,
                  width: 150.0,
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  colorBlendMode: BlendMode.modulate,
                ),
                Text(
                  "Touros e Inseminação",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.0,
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
