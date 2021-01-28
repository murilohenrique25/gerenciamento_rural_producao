import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/utilitarios/economia.dart';
import 'package:gerenciamento_rural/screens/utilitarios/lote.dart';
import 'package:gerenciamento_rural/screens/utilitarios/medicamentos.dart';
import 'package:gerenciamento_rural/screens/utilitarios/cadastrar_tratamento.dart';
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
                accountName: Text("Gestão Rural"),
                accountEmail: Text("gestaorural@gest.com"),
                currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/logos.png'),
                ),
              ),
              DrawerTile(Icons.arrow_right, "Lotes", Lotes()),
              DrawerTile(Icons.arrow_right, "Medicamentos", Medicamentos()),
              DrawerTile(
                  Icons.arrow_right, "Tratamentos", CadastroTratamento()),
              DrawerTile(Icons.arrow_right, "Economia", Economia()),
            ],
          ),
        ],
      ),
    );
  }
}
