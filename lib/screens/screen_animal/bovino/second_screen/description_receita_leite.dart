import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/cadastro_receita_leite.dart';

class DescriptionReceitaLeite extends StatefulWidget {
  @override
  _DescriptionReceitaLeiteState createState() =>
      _DescriptionReceitaLeiteState();
}

class _DescriptionReceitaLeiteState extends State<DescriptionReceitaLeite> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroReceitaLeite()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "images/prancheta.jpg",
                    width: 150.0,
                    height: 150.0,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    colorBlendMode: BlendMode.modulate,
                  ),
                  Text(
                    "Receitas do leite",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1.0,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
