import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'configuracoes_locais.dart';
import 'home_page.dart';

class Deposito extends StatefulWidget {
  ConfiguracoesLocais configs = ConfiguracoesLocais();

  @override
  State<Deposito> createState() => _DepositoState();
}

class _DepositoState extends State<Deposito> {
  final TextEditingController _valorController = TextEditingController();

  final TextEditingController _contaDestinoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    tooltip: 'Voltar',
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return HomePage(configs: widget.configs);
                      }));
                    }),
                Text("Depósito"),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _contaDestinoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Conta de Destino'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Valor do Depósito'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _realizarDeposito(context, _contaDestinoController.text,
                        _valorController.text);
                  },
                  child: Text('Transferir'),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }

  void _realizarDeposito(BuildContext context, conta, valor) async {
    if (_valorController.text.isNotEmpty &&
        _contaDestinoController.text.isNotEmpty) {
      Map<String, String> headers = {"Content_Type": "application/json"};
      if (double.parse(valor) <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erro ao realizar depósito: valor menor ou igual a 0'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // double value = valor as double;
      final String apiUrl =
          'http://10.0.2.2:8080/operacao/depositar/$conta/$valor';

      final response = await http.post(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        widget.configs.setSaldo(double.parse(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Depósito realizado com sucesso. Novo saldo: ${response.body}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar depósito: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
