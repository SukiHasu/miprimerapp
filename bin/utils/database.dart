import 'package:mysql1/mysql1.dart';

abstract class DataBase {
  static final String _host = "localhost"; //127.0.0.0
  static final int _port = 3306;
  static final String _user = "root";
  static final String _dbName = "miprimera_db";


  static Future<void> instalacion() async {
    var settings = ConnectionSettings(
      host: _host, 
      port: _port,
      user: _user
      );

    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query("CREATE DATABASE IF NOT EXISTS $_dbName");
    await conn.query("USE $_dbName");
    await crearTablaUsers(conn);
    await crearTablaPokemon(conn);
    await crearTablaUsersPokemon(conn);
    await conn.close();
  }

 static Future <MySqlConnection> obtenerConexion() async { 
   var settings = ConnectionSettings(
      host: _host, 
      port: _port,
      user: _user,
      db: _dbName
      );

    MySqlConnection conn = await MySqlConnection.connect(settings);
    return conn;
}


  static Future<void> crearTablaUsers(MySqlConnection conn) async {
    await conn.query("""CREATE TABLE IF NOT EXISTS users(
    idusuario INT PRIMARY KEY AUTO_INCREMENT, 
    nombre VARCHAR(20) NOT NULL, 
    nick VARCHAR(20) NOT NULL UNIQUE, 
    password VARCHAR(20) NOT NULL,
    monedas INT
    )""");
  }


  static Future<void> crearTablaPokemon(MySqlConnection conn) async {
    await conn.query("""CREATE TABLE IF NOT EXISTS pokemon(
    id INT PRIMARY KEY AUTO_INCREMENT, 
    nombre VARCHAR(50) NOT NULL, 
    tipo1 VARCHAR(50) NOT NULL, 
    tipo2 VARCHAR(50),
    ataque INT NOT NULL,
    defensa INT NOT NULL,
    hp INT NOT NULL,
    velocidad INT NOT NULL,
    ataqueesp INT NOT NULL,
    defensaesp INT NOT NULL)""");
  }

  static Future<void> crearTablaUsersPokemon(MySqlConnection conn) async {
    await conn.query("""CREATE TABLE IF NOT EXISTS usuariopokemon(
    id INT PRIMARY KEY AUTO_INCREMENT, 
    idusuariospokemon INT NOT NULL, 
    idusuarios INT NOT NULL, 
    idpokemon INT NOT NULL,
    apodo INT NOT NULL)""");
  }

}
  /*
  await es una palabra reservada que detiene una ejecución hasta que se completa.
  Cuando en un método tengo que hacer una instrucción que se ejecuta fuera de mi aplicación
  pierdo la sincronía.
  async: propiedad que indica que es asincrono, permite usar el await.
  future: se pone para indicar que el metodo va a devolver algo en el futuro.

  query se utiliza para lanzar sentencias a la bbdd.

  Es decir, hace que nuestro código entre en pausa hasta que se ejecuta la aplicación externa
  y entonces mueve el programa. De esta forma evitamos que nuestro código se salte la ejecución 
  del programa externo.
  */

  /*
  Un método es estático cuando podemos acceder a él sin la necesidad de crear un objeto. Se usa para 
  no depender de un objeto en una propiedad.
  Una clase es abstracta cuando no queremos que se puedan crear objetos de ella.

  Que una propiedad/metodo sean estaticos significa que podemos usarlos sin la necesidad de crear un 
  objeto de esa clase.

  Un objeto es una clase cuyas propiedades tienen unos valores.

  final/cons valen para que no puedas cambiar el valor a esas variables. La diferencia está en qué 
  momento impide el cambio de valor. Cuando ponemos cons al compilarse el programa directamente lo 
  sustituye con ese valor, pero en final sigue siendo una variable "normal" pero solo que "protegida", 
  no deja cambiarla directamente.*/
