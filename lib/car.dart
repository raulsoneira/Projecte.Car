import 'dbhelper.dart';



class Taxi {
  int? id;
  String? model;
  int? matricula;
  int? passatgers;

  Taxi(this.id, this.model, this.matricula, this.passatgers);

  Taxi.fromMap(Map<String, dynamic> map) { //Creem un nou array amb els resultats de la funcio
    id = map['id'];
    model = map['model'];
    matricula = map['matricula'];
    passatgers = map['passatgers'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnModel: model,
      DatabaseHelper.columnMatricula: matricula,
      DatabaseHelper.columnPassatger: passatgers,
    };
  }
}