import 'dart:convert';
import 'dart:math';
import '../utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

class Pokemon extends ModelClass {
  int? idpokemon;
  String? nombre;
  String? tipo1;
  String? tipo2;
  int ataque=0;
  int defensa=0;
  int hp=0;
  int velocidad=0;
  int ataqueesp=0;
  int defensaesp=0;
  @override
  String tableName="pokemon";
 @override
  Map? primaryKey()=>{"idpokemon":idpokemon};
  @override
  Map?campos() =>{"idpokemon":idpokemon,"nombre":nombre, "tipo1":tipo1,
  "tipo2":tipo2,"ataque":ataque,"defensa":defensa,"hp":hp,"velocidad":velocidad,
  "ataqueesp":ataqueesp,"defensaesp":defensaesp};

  Pokemon({
    required this.idpokemon,
    required this.nombre,
    required this.tipo1,
    this.tipo2,
    required this.ataque,
    required this.defensa,
    required this.hp,
    required this.velocidad,
    required this.ataqueesp,
    required this.defensaesp,
  });
  Pokemon.fromApi(Map<String,dynamic> data){
  idpokemon = data['id']?? -1;
    nombre = data['name'] ?? "";
    tipo1 = data['types'][0]['type']['name'] ?? "";
    if (data['types'].length > 1) {
      tipo2 = data['types'][1]['type']['name'] ?? "";
    }
    hp = data['stats'][0]['base_stat'] ?? 0;
    ataque = data['stats'][1]['base_stat'] ?? 0;
    defensa = data['stats'][2]['base_stat'] ?? 0;
    ataqueesp = data['stats'][3]['base_stat'] ?? 0;
    defensaesp = data['stats'][4]['base_stat'] ?? 0;
    velocidad = data['stats'][5]['base_stat'] ?? 0;
  }

Pokemon.fromDataBase(ResultRow row){
idpokemon = row['idpokemon']?? -1;
    nombre = row['nombre'] ?? "";
    tipo1 =  row['tipo1'] ?? "";
    tipo2 =  row['tipo2']?? "";
    hp =  row['hp'] ?? 0;
    ataque =  row['ataque'] ?? 0;
    defensa =  row['defensa'] ?? 0;
    ataqueesp =  row['ataqueesp']?? 0;
    defensaesp =  row['defensaesp'] ?? 0;
    velocidad =  row['velocidad'] ?? 0;

}
@override
Pokemon fromDataBase(ResultRow row) => Pokemon.fromDataBase(row);

  static Future<Pokemon?> obtenerPokemon(String identificador) async {
    var url = Uri.parse("https://pokeapi.co/api/v2/pokemon/$identificador");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
     Pokemon pokemon = Pokemon.fromApi(data);
     return pokemon;

    }
    return null;
  }

int valorarPokemon(){
  double promedio= (hp+velocidad+ataque+defensa+ataqueesp+defensaesp)/6;
  int redondeando = promedio.round();
  int valor=Random().nextInt(redondeando*2);
  return valor;
}
Future<bool>comprar(int pokemonComprado)async{
  return true;
}

Future <List<Pokemon>> all() async{
  MySqlConnection conn= await DataBase.obtenerConexion();
  var registros= await  conn.query("SELECT * FROM pokemon");

  List<Pokemon>listado=[];
for(ResultRow registro in registros){
  Pokemon pokemon= Pokemon.fromDataBase(registro);
  listado.add(pokemon);
}


  return listado;
}


}

