import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trabalho_faculdade/entidades/usuario.dart';

class Pref {

  static const _storage = FlutterSecureStorage();

  static Future<bool> save(String key, String value) async {
    try{
      await _storage.write(key: key, value: value);
      return true;
    }catch(e){
      return false;
    }
  }

  Future<Usuario?> getUser() async {
    var res = await get('user');
    if (res == "") {
      return null;
    } else {
      return Usuario.fromMap(jsonDecode(res));
    }
  }

  static Future<void> saveUser(Usuario user) async {
    await save('user', jsonEncode(user.toMap()));
  }


  Future<String> get(String key) async {
    return await _storage.read(key: key) ?? "";
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }
}