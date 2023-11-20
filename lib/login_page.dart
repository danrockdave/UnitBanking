import 'package:flutter/material.dart';
import 'package:unitbankapp/configuracoes_locais.dart';
import 'package:unitbankapp/home_page.dart';
import 'package:unitbankapp/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cores.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: NumeroContaInput(),
        ),
      ),
    );
  }
}

class NumeroContaInput extends StatefulWidget {
  ConfiguracoesLocais configs = new ConfiguracoesLocais();
  @override
  _NumeroContaInputState createState() => _NumeroContaInputState();
}

class _NumeroContaInputState extends State<NumeroContaInput> {
  final TextEditingController _numeroContaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _numeroContaController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Número da Conta',
            hintText: 'Digite o número da conta',
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            _realizarLogin(_numeroContaController.text);
          },
          child: Text('Acessar'),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {

          },
          child: Text('Criar Conta'),
        ),
      ],
    );
  }


  _realizarLogin(conta) async{
    if(_numeroContaController.text.isNotEmpty){
      Map<String, String> headers = {"Content_Type": "application/json"};
      final String apiUrl = 'http://10.0.2.2:8080/conta/numero/$conta';
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.body.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sucesso ao realizar login.'),
          ),
        );
        Map<dynamic,dynamic> mapa = json.decode(response.body);
        widget.configs.setSaldo(mapa["saldo"]);
        widget.configs.setNome(mapa["nome"]);
        widget.configs.setConta(mapa["numeroConta"]);

        push(context, HomePage(configs: widget.configs));
            /*id:mapa["id"], conta:mapa["numeroConta"],
        nome:mapa["nome"], saldo: mapa["saldo"]*/
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar login.'),
            backgroundColor: Colors.red,
          ),
        );
      }

    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha o campo Conta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}