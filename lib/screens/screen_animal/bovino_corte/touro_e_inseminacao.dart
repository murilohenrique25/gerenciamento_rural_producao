import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/rebanho.dart';

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
            setState(() {});
            Navigator.push(
                context,
                // ignore: non_constant_identifier_names
                MaterialPageRoute(builder: (BuildContext) => Rebanho()));
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
                  "Touro\nInseminação",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
