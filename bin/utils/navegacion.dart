import 'dart:io';
import '../entities/entities.dart';
import 'utils.dart';

/* Las propiedades y métodos estáticos NO pertenecen a los objetos, es decir, podemos acceder a esas 
propiedades y ejecutarlas SIN crear un objeto de esa clase.
Cuando una clase es abstracta, los métodos tienen que ser estáticos.
*/

abstract class Navegacion {
  static String inicio = "principal";

  static String principal() {
    String opcion;
    do {
      stdout.writeln("""Elige una opción:
    1. Iniciar sesión
    2. Registrarse
    3. Salir""");
      opcion = stdin.readLineSync() ?? "Error";
      if (opcion != "1" && opcion != "2" && opcion != "3") {
        stdout.writeln("Opción no válida");
      }
    } while (opcion != "1" && opcion != "2" && opcion != "3");
    if (opcion == "1") {
      return "login";
    } else if (opcion == "2") {
      return "registro";
    } else {
      return "salir";
    }
  }

  static Future<String> registro() async {
    String nombre;
    String nick;
    String password;
    Map<String, String> datos = {};
    do {
      stdout.writeln("""Registro:
  Introduce tu nombre""");
      nombre = stdin.readLineSync() ?? "Error";
      stdout.writeln("Introduce tu nick");
      nick = stdin.readLineSync() ?? "Error";
      stdout.writeln("Introduce tu contraseña");
      password = stdin.readLineSync() ?? "Error";
      if (nombre.isEmpty || nick.isEmpty || password.isEmpty) {
        stdout.writeln("Ningún campo puede estar vacío");
      }
      if (password.length < 6) {
        stdout.writeln("La contraseña no puede tener menos de 6 caracteres");
      }
    } while (nombre.isEmpty ||
        nick.isEmpty ||
        password.isEmpty ||
        password.length < 6);

    datos = {"nombre": nombre, "nick": nick, "password": password};
    bool registrado = await Usuario.registro(datos);
    if (registrado) {
      print("Te has registrado correctamente");
      return "principal";
    } else {
      print("El usuario ya existe, vuelve a intentarlo");
      return "registro";
    }
  }

  static Future<String> login() async {
    String nick;
    String password;
    do {
      stdout.writeln("""Login:
  Introduce tu nick""");
      nick = stdin.readLineSync() ?? "Error";
      stdout.writeln("Introduce tu contraseña");
      password = stdin.readLineSync() ?? "Error";
      if (nick.isEmpty || password.isEmpty) {
        stdout.writeln("Ningún campo puede estar vacío");
      }
      if (password.length < 6) {
        stdout.writeln("La contraseña no puede tener menos de 6 caracteres");
      }
    } while (nick.isEmpty || password.isEmpty || password.length < 6);

    bool logeado = await Sesion.login(nick, password);
    if (logeado) {
      print("Bienvenido ${Sesion.usuario!.nombre}");
      return "home";
    } else {
      print("Tu nick o contraseña son incorrectos, adios");
      return "principal";
    }
  }

  static String home() {
    String opcion;
    do {
      stdout.writeln("""Elige una opción:
    1. Buscar y comprar un pokemon
    2. Quiz Pokemon
    3. Compra Aleatoria
    4.Mi equipo
    5.Salir""");
      opcion = stdin.readLineSync() ?? "Error";
      if (
      opcion != "1" && 
      opcion != "2" && 
      opcion != "3" &&
      opcion != "4" &&
      opcion != "5" ) {stdout.writeln("Opción no válida");
      }
    } while (opcion != "1" && opcion != "2" && opcion != "3" &&opcion != "4"&&opcion != "5");
    if (opcion == "1") {
      return "Buscar";
    } else if (opcion == "2") {
      return "home";
    } 
    else if (opcion == "3") {
      return "home";
    }
    else if (opcion == "4") {
      return "home";
    }
    else {
      return "salir";
    }
  }
}