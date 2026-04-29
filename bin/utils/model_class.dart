import 'package:mysql1/mysql1.dart';
import '../utils/utils.dart';

abstract class ModelClass {
  abstract String tableName;
 // abstract String primaryKey;

  fromDataBase(ResultRow row);
  campos();
  primaryKey();

  Future<List> all() async {
    //listado basico
    MySqlConnection? conn;
    List listado = [];
    try {
      conn = await DataBase.obtenerConexion();
      var registros = await conn.query("SELECT * FROM $tableName");
      for (ResultRow registro in registros) {
        listado.add(fromDataBase(registro));
      }
      return listado;
    } catch (error) {
      print(error);
      return listado;
    } finally {
      if (conn != null) {
        // conn?.close();
        conn.close(); //
      } //
    }
  }

  Future get(int id) async {
    MySqlConnection? conn;

    try {
      conn = await DataBase.obtenerConexion();
      var registro = await conn.query(
        "SELECT * FROM $tableName WHERE $primaryKey= ?",[id]
      );
      return fromDataBase(registro.first);
    } catch (error) {
      print(error);
      return null;
    } finally {
      if (conn != null) {
        conn.close();
      }
    }
  }

 dynamic save() async {
    if (await exists()) {
     // await update();
    } else {
      await insert();
    }
  }

  Future<bool> exists() async {
    MySqlConnection conn = await DataBase.obtenerConexion();
    var respuesta = await conn.query(
      'SELECT*FROM $tableName WHERE $primaryKey=?',[]
    );
    return respuesta.isNotEmpty;
  }

  Future<bool> insert() async {
    MySqlConnection conn = await DataBase.obtenerConexion();
    String listaCampos = campos().keys.join(',');
    List valores = campos().values.toList();
    String interrogantes = valores.map((e) => "?").join(',');
    await conn.query(
      'INSERT INTO $tableName ($listaCampos) VALUES ($interrogantes)',
      valores,
    );
    await conn.close();
    return true;
  }
}
