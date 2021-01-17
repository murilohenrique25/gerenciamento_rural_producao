import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/list_inseminacoes.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/list_inventario_semen.dart';

class InventarioSemen extends StatefulWidget {
  @override
  _InventarioSemenState createState() => _InventarioSemenState();
}

class _InventarioSemenState extends State<InventarioSemen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListInventarioSemen()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "images/botijaosemen.jpg",
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
                        "Inseminação",
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
