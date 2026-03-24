import 'package:mysql1/mysql1.dart';
import '../utils/utils.dart';


class Usuario {
  int? idusuario;
  String? nombre;
  String? nick;
  String? password;
  
  Usuario(this.idusuario,this.nombre,this.nick,this.password);

//creamos una funcion para el registro del usuario y su correcion
  static Future <bool> registro(Map<String, String>datos)async{
    MySqlConnection conn =  await DataBase.obtenerConexion();

    var respuesta = await conn.query ('SELECT * FROM users WHERE nick= ?', [datos['nick']]);
    bool existe = respuesta.isNotEmpty;
    if(existe){    
      await conn.close(); //da error si es el mismo el usuario
      return false;
    }
    await conn.query('INSERT INTO users (nombre,nick,password) VALUES (?,?,?)',
    [datos ['nombre'], datos['nick'], datos ['password']],
    );
    await conn.close();
    return true;
  }


 
}