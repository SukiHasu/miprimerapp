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
      print(
        "Te has registrado correctamente. Has conseguido 100 monedas de oro en tu cuenta pokemon de regalo!",
      );
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
      print("Bienvenido ${Sesion.usuario!.nombre},");
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
    1. Buscar y comprar Pokemon
    2. Quiz Pokemon
    3. Compra aleatoria
    4. Mi equipo
    5. Salir""");
      opcion = stdin.readLineSync() ?? "Error";
      if (_opcionInvalida(opcion, 5)) {
        stdout.writeln("Opción no válida");
      }
    } while (_opcionInvalida(opcion, 5));

    switch (opcion) {
      case "1":
        return "buscar";
      case "2":
        print("Esta opción no está disponible");
        return "home";
      case "3":
        print("Esta opción no está disponible");
        return "home";
      case "4":
        print("Esta opción no está disponible");
        return "home";
      default:
        return "principal";
    }
  }

  static Future<String> buscar() async {
    print("Escribe el nombre o el id del pokemon que quieres buscar");
    String respuesta = stdin.readLineSync() ?? "Error";
    Pokemon? pokemon = await Pokemon.obtenerPokemon(respuesta);
    if (pokemon == null) {
      print("Error: algo ha ido mal al obtener el Pokemon");
      return "buscar";
    }
    print("""Has encontrado un Pokemon!!
    Nombre: ${pokemon.nombre}
    Tipo principal:${pokemon.tipo1}
    Tipo secundario:${pokemon.tipo2 ?? "---"}
    Vida: ${pokemon.hp}
    Velocidad: ${pokemon.velocidad}
    Ataque: ${pokemon.ataque}
    Defensa: ${pokemon.defensa}
    Ataque especial:${pokemon.ataqueesp}
    Defensa especial:${pokemon.defensaesp}
    """);
    int valorPokemon = pokemon.valorarPokemon();
    print("El valor de este pokemon es $valorPokemon}");
    String opcion;
    do {
      print("""Quieres comprarlo?
    1.Si
    2.No""");
      opcion = stdin.readLineSync() ?? "Error";
      if (_opcionInvalida(opcion, 2)) {
        stdout.writeln("opcion no valida");
      }
    } while (_opcionInvalida(opcion, 2));
    if (opcion == "1") {
      int? oferta = _getOferta();

      if (valorPokemon <= oferta) {
        bool comprado = true;
        if (comprado) {
          Sesion.usuario!.restarMonedas(oferta);
        }
      } else {
        print("Lo siento, tu oferta no ha sido suficiente");
        Sesion.usuario!.restarMonedas((oferta * 0.2).toInt());
      }
      Sesion.usuario!.save();
      return "buscar";
    } else {
      print("Sin problema, puedes buscar otro pokemon");
      return "buscar";
    }
  }

  static bool _opcionInvalida(String opcion, int numero) {
    return (int.tryParse(opcion) ?? 0) > numero ||
        (int.tryParse(opcion) ?? 0) < 1;
  }

  static int _getOferta() {
    int? oferta;
    do {
      print("Estupendo! ¿Cuánto estás dispuesto a pagar por él?");
      String respuesta = stdin.readLineSync() ?? "Error";
      oferta = int.tryParse(respuesta);
      if (oferta == null) {
        print("debes introducir un numero entero");
      } else if (oferta > Sesion.usuario!.monedas) {
        print("No tienes tantas monedas!");
      }
    } while (oferta == null || oferta > Sesion.usuario!.monedas);
    return oferta;
  }
}
