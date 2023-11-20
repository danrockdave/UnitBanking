import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracoesLocais {
  SharedPreferences? _prefs;

  ConfiguracoesLocais() {
    _iniciarConfigs();
  }

  Future<void> _iniciarConfigs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  limparPreferencias() {
    _prefs!.clear();
  }

  setSaldo(double saldo) {
    return _prefs!.setDouble('saldo', saldo);
  }

  getSaldo() {
    return _prefs!.getDouble('saldo') ?? 0;
  }

  setNome(String nome) {
    return _prefs!.setString('nome', nome);
  }

  getNome() {
    return _prefs!.getString('nome') ?? '';
  }

  setConta(String conta) {
    return _prefs!.setString('conta', conta);
  }

  getConta() {
    return _prefs!.getString('conta') ?? '';
  }
}
