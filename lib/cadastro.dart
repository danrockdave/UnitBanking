import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cadastro extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _numeroContaController = TextEditingController();
  final TextEditingController _saldoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _numeroContaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Número da Conta'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _saldoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Saldo'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _realizarCadastro(context);
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  void _realizarCadastro(BuildContext context)async {
    final nome = _nomeController.text;
    final numeroConta = _numeroContaController.text;
    final saldo = _saldoController.text;
    if(nome.isNotEmpty && numeroConta.isNotEmpty && saldo.isNotEmpty){
      Map<String, String> headers = {"Content_Type": "application/json"};
      String apiUrl ='http://10.0.2.2:8080/conta/$nome/$numeroConta/$saldo';
      final response = await http.post(Uri.parse(apiUrl), headers: headers);
      if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
          ),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos!'),
        ),
      );
    }

  }
}