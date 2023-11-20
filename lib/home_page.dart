import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:unitbankapp/configuracoes_locais.dart';
import 'package:unitbankapp/deposito.dart';
import 'package:unitbankapp/saque.dart';
import 'package:unitbankapp/transferencia.dart';
import 'package:unitbankapp/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  ConfiguracoesLocais configs = new ConfiguracoesLocais();

  HomePage({required this.configs});

  double meuSaldo = 0;

  @override
  Widget build(BuildContext context) {
    meuSaldo = configs.getSaldo();
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("UnitBank"),
                IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    tooltip: 'Sair',
                    onPressed: () {
                      configs.limparPreferencias();
                      Phoenix.rebirth(context);
                    }),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Nome: ${configs.getNome()}\nConta: ${configs.getConta()}\n" +
                        "Saldo: ${meuSaldo} \n",
                    style: TextStyle(fontSize: 23),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    push(context, Transferencia());
                  },
                  child: Text('Transferência'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    push(context, Deposito());
                  },
                  child: Text('Depósito'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    push(context, Saque());
                  },
                  child: Text('Saque'),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
