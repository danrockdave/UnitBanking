import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'configuracoes_locais.dart';
import 'home_page.dart';

class Saque extends StatefulWidget {
  ConfiguracoesLocais configs = ConfiguracoesLocais();

  @override
  State<Saque> createState() => _SaqueState();
}

class _SaqueState extends State<Saque> {
  final TextEditingController _valorController = TextEditingController();

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
                Text("Saque"),
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
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Valor do Saque'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _realizarSaque(context, _valorController.text);
                  },
                  child: Text('Sacar'),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }

  void _realizarSaque(BuildContext context, valor) async {
    if (_valorController.text.isNotEmpty) {
      Map<String, String> headers = {"Content_Type": "application/json"};
      if (double.parse(valor) <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar saque: valor menor ou igual a 0'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // double value = valor as double;
      final String apiUrl = 'http://10.0.2.2:8080/operacao/sacar/${widget.configs.getConta()}/$valor';

      final response = await http.post(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        widget.configs.setSaldo(double.parse(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Saque realizado com sucesso. Novo saldo: ${response.body}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar saque: ${response.body}'),
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
