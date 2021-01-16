import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/screens/utilitarios/cadastrar_lote.dart';

enum OrderOptions { orderaz, orderza }

class Lotes extends StatefulWidget {
  @override
  _LotesState createState() => _LotesState();
}

class _LotesState extends State<Lotes> {
  LoteDB helper = LoteDB();
  List<Lote> lotes = List();
  @override
  void initState() {
    super.initState();
    _getAllLotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showLotePage();
              }),
        ],
        centerTitle: true,
        title: Text("Lotes"),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: lotes.length,
          itemBuilder: (context, index) {
            return _loteCard(context, index);
          }),
    );
  }

  Widget _loteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                lotes[index].name ?? "",
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(
                width: 15,
              ),
              Text(" - "),
              SizedBox(
                width: 15,
              ),
              Text(
                lotes[index].codigoExterno ?? "",
                style: TextStyle(fontSize: 14.0),
              )
            ],
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
                          _showLotePage(lote: lotes[index]);
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
                          helper.delete(lotes[index].id);
                          setState(() {
                            lotes.removeAt(index);
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

  void _showLotePage({Lote lote}) async {
    final recLote = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroLote(
                  lote: lote,
                )));
    if (recLote != null) {
      if (lote != null) {
        await helper.updateItem(recLote);
      } else {
        await helper.insert(recLote);
      }
      _getAllLotes();
    }
  }

  void _getAllLotes() {
    helper.getAllItems().then((list) {
      setState(() {
        lotes = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        lotes.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        lotes.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
