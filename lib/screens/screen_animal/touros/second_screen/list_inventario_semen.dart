import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/tree_screen/cadastrar_inseminacao.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/tree_screen/cadastrar_inventario_semen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/tree_screen/cadastrar_touro.dart';

enum OrderOptions { orderaz, orderza }

class ListInventarioSemen extends StatefulWidget {
  @override
  _ListInventarioSemenState createState() => _ListInventarioSemenState();
}

class _ListInventarioSemenState extends State<ListInventarioSemen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CadastroInventarioSemen()));
              }),
        ],
        centerTitle: true,
        title: Text("Inventário"),
      ),
      body: Center(
        child: Container(
          child: Text("Aqui será lista todas \nsêmens coletados."),
        ),
      ),
    );
  }
}
