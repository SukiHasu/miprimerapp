import "dart:io";
import "entities/usuario.dart";
import 'utils/utils.dart';

void main() async {
  await DataBase.instalacion();
  String menu = Navegacion.inicio;
  while (true) {
    switch (menu) {
      case "principal":
        menu = Navegacion.principal();
        break;

      case "registro":
        menu = await Navegacion.registro();
        break;

      case "login":
        menu = await Navegacion.login();

        break;

      case "home":
        menu = Navegacion.home();
        break;
      case "buscar":
        menu = await Navegacion.buscar();
        break;
    }
    if (menu == "salir") {
      print("Has elegido salir, bye bye!!");
      break;
    }
  }
}



  
 /* switch (opcion) {
    case "1":
    Map<String, String> datos= Navegacion.registro();

     Usuario usuario = Usuario();
      bool registrado =usuario.registro(datos);
     if (registrado){
      stdout.writeln ("usuario registrado correctamente");
     }else { stdout.writeln("ese usuario ya esta ocupado");
     }
      break;

    case "2":
      break;
  }*/

