import '../entities/usuario.dart';
import 'utils.dart';
import 'package:mysql1/mysql1.dart';

abstract class Sesion {
  static Usuario? usuario;

  static Future<bool> login(String nick, String password) async {
    MySqlConnection conn = await DataBase.obtenerConexion();
    var respuesta = await conn.query('SELECT * FROM users WHERE nick = ?', [
      nick,
    ]);

    bool noExiste = respuesta.isEmpty;
    if (noExiste || respuesta.first[3] != password) {
      // si no existe o contraseña no coincide, devuelve false
      await conn.close();
      return false;
    }
    // como el usuarui existe y contraseña correcta, devuelve true
    await conn.close();
    usuario = Usuario.fromDataBase(respuesta.first);
    return true;
  }
}
