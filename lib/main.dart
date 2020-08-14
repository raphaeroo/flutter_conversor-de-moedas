import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=16cbb3f0";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  var results = json.decode(response.body);
  return results;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        brightness: Brightness.light,
        title:
            Text("Conversor de Moedas", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text('Carregando...',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.amber, fontSize: 25)));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text('Erro ao carregar dados =(',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.amber, fontSize: 25)));
              }
              dolar = snapshot.data['results']['currencies']['USD']['buy'];
              euro = snapshot.data['results']['currencies']['EUR']['buy'];

              return SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 25),
                      child: Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                    ),
                    buildTextField('Reais', 'R\$ '),
                    Divider(),
                    buildTextField('Dólares', 'US\$ '),
                    Divider(),
                    buildTextField('Euros', '€ ')
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix) {
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        prefixText: prefix,
        border: OutlineInputBorder()),
    style: TextStyle(color: Colors.amber),
  );
}
