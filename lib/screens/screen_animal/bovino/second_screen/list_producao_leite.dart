import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/producao_leite_db.dart';
import 'package:gerenciamento_rural/models/producao_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/cadastro_leite.dart';

enum OrderOptions { orderaz, orderza }

class ProducoesLeite extends StatefulWidget {
  @override
  _ProducoesLeiteState createState() => _ProducoesLeiteState();
}

class _ProducoesLeiteState extends State<ProducoesLeite> {
  ProducaoLeiteDB helper = ProducaoLeiteDB();
  List<ProducaoLeite> prodLeite = List();
  @override
  void initState() {
    super.initState();
    _getAllProducaoLeites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Id(Crescente)"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Id(Decrescente)"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showProducaoLeitePage();
              }),
        ],
        centerTitle: true,
        title: Text("Produção de Leite"),
      ),
      body: ListView.builder(
          itemCount: prodLeite.length,
          itemBuilder: (context, index) {
            return _producaoLeiteCard(context, index);
          }),
    );
  }

  Widget _producaoLeiteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Id:" + prodLeite[index].id.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Data: " + prodLeite[index].dataColeta,
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Quant.: " + prodLeite[index].quantidade.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Gord.: " + prodLeite[index].gordura.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Prot.: " + prodLeite[index].proteina.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Lact.: " + prodLeite[index].lactose.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Ur.: " + prodLeite[index].ureia.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showProducaoLeitePage(
                              producaoLeite: prodLeite[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helper.delete(prodLeite[index].id);
                          setState(() {
                            prodLeite.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showProducaoLeitePage({ProducaoLeite producaoLeite}) async {
    final recProducaoLeite = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroLeite(
                  producaoLeite: producaoLeite,
                )));
    if (recProducaoLeite != null) {
      if (producaoLeite != null) {
        await helper.updateItem(recProducaoLeite);
      } else {
        await helper.insert(recProducaoLeite);
      }
      _getAllProducaoLeites();
    }
  }

  void _getAllProducaoLeites() {
    helper.getAllItems().then((list) {
      setState(() {
        prodLeite = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        prodLeite.sort((a, b) {
          return a.id.compareTo(b.id);
        });
        break;
      case OrderOptions.orderza:
        prodLeite.sort((a, b) {
          return b.id.compareTo(a.id);
        });
        break;
    }
    setState(() {});
  }
}
