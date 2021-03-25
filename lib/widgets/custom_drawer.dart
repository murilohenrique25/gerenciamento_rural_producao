import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/list_preco_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/list_preco_carne.dart';
import 'package:gerenciamento_rural/screens/utilitarios/economias_gastos.dart';
import 'package:gerenciamento_rural/screens/utilitarios/lotes.dart';
import 'package:gerenciamento_rural/screens/utilitarios/relatorios/relatorios.dart';
import 'package:gerenciamento_rural/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() {
      var linearGradient = LinearGradient(
          colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
          begin: Alignment.bottomCenter,
          end: Alignment.topRight);
      return Container(
        decoration: BoxDecoration(
          gradient: linearGradient,
        ),
      );
    }

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(top: 16.0),
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Control IF Goiano"),
                accountEmail: Text("control@institutofederal.com.br"),
                currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/logos.png'),
                ),
              ),
              DrawerTile(Icons.arrow_right, "Lotes", Lotes()),
              //DrawerTile(Icons.arrow_right, "Medicamentos", MedicamentosList()),
              // DrawerTile(
              //     Icons.arrow_right, "Tratamentos", CadastroTratamento()),
              DrawerTile(Icons.arrow_right, "Gastos", Economia()),
              DrawerTile(Icons.arrow_right, "Relatorios", Relatorios()),
              DrawerTile(Icons.arrow_right, "Preço do Leite", PrecoLeiteList()),
              DrawerTile(Icons.arrow_right, "Preço da Carne Suína",
                  PrecoCarneSuinaList()),
            ],
          ),
        ],
      ),
    );
  }
}
