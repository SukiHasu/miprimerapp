import 'package:mysql1/mysql1.dart';
import '../utils/utils.dart';


class Usuario  extends ModelClass{
  int? id;
  String? nombre;
  String? nick;
  String? password;
  int monedas= 0;
  @override
  String tableName="users";
  @override
  Map? primaryKey()=>{"id":id};
  @override
  Map? campos() =>{"nombre":nombre, "nick":nick,"password":password,"monedas":monedas};
  
  Usuario.nulo();
  Usuario(this.id,this.nombre,this.nick,this.password,this.monedas);



 Usuario.fromDataBase(ResultRow row){
    id = row['id']?? -1;
    nombre = row['nombre'] ?? "";
    nick=  row['nick'] ?? "";
    password =  row['password']?? "";
    monedas =  row['monedas'] ?? 0;

}
 @override
Usuario fromDataBase(row)=> Usuario.fromDataBase(row);


//creamos una funcion para el registro del usuario y su correcion
  static Future <bool> registro(Map<String, String>datos)async{
    MySqlConnection conn =  await DataBase.obtenerConexion();

    var respuesta = await conn.query ('SELECT * FROM users WHERE nick= ?', [datos['nick']]);
    bool existe = respuesta.isNotEmpty;
    if(existe){    
      await conn.close(); //da error si es el mismo el usuario
      return false;
    }
    await conn.query('INSERT INTO users (nombre,nick,password,monedas) VALUES (?,?,?,?)',
    [datos ['nombre'], datos['nick'], datos ['password'],100]
    );
    await conn.close();
    return true;
  }

bool restarMonedas(int cantidad){
  if(monedas >= cantidad){
 monedas-=cantidad;
 return true;
 }else{
  return false;
 }

}


}
