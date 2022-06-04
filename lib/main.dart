import 'car.dart';
import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'package:projecte_car/car.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'TAXIRAUL';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
          brightness: Brightness.light,

          // Define the default font family.
          fontFamily: 'Arial'),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'TAXIRAUL',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),


            Container(
                child: Image.asset(
              'assets/taxiii.gif',
              width: 200,
              height: 200,
            )),
            Container(

                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(

                  child: const Text('Login'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )),
            Container(
                child: Image.asset(
                  'assets/taxi2.gif',
                  width: 200,
                  height: 200,
                )),
          ],
        ));
  }
}

//----------------------inserir,update-----------------------
void main() => runApp(MyApp());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;

  List<Taxi> taxis = [];
  List<Taxi> nomtaxis = [];

  //controllers used in insert operation UI
  TextEditingController nameController = TextEditingController();
  TextEditingController milesController = TextEditingController();
  TextEditingController passatgersController = TextEditingController();

  //controllers used in update operation UI
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController milesUpdateController = TextEditingController();
  TextEditingController passatgersUpdateController = TextEditingController();

  //controllers used in delete operation UI
  TextEditingController idDeleteController = TextEditingController();

  //controllers used in query operation UI
  TextEditingController queryController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Inserir",
              ),
              Tab(
                text: "Llistar",
              ),
              Tab(
                text: "Buscar",
              ),
              Tab(
                text: "Actualitzar",
              ),
              Tab(
                text: "Delete",
              ),
            ],
          ),
          title: Text('TAXIRAUL'),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Model Taxi',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: milesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Matrícula',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: passatgersController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Passatgers',
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Inserir Taxi'),
                    onPressed: () {
                      String model = nameController.text;
                      int matricula = int.parse(milesController.text);
                      int passatgers = int.parse(passatgersController.text);
                      _insert(model, matricula, passatgers);
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: taxis.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == taxis.length) {
                    return RaisedButton(
                      child: Text('Refresh'),
                      onPressed: () {
                        setState(() {
                          _queryAll();
                        });
                      },
                    );
                  }
                  return Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        '[${taxis[index].id}] ${taxis[index].model} - ${taxis[index].matricula} matricula',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: queryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Model Taxi',
                      ),
                      onChanged: (text) {
                        if (text.length >= 2) {
                          setState(() {
                            _query(text);
                          });
                        } else {
                          setState(() {
                            nomtaxis.clear();
                          });
                        }
                      },
                    ),
                    height: 100,
                  ),
                  Container(
                    height: 300,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: nomtaxis.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          child: Center(
                            child: Text(
                              '[${nomtaxis[index].id}] ${nomtaxis[index].model} - ${nomtaxis[index].matricula} matricula',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: idUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Taxi id',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: nameUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Model Taxi',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: milesUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Matrícula',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: passatgersUpdateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Passatgers',
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Actualitzar taxi'),
                    onPressed: () {
                      int id = int.parse(idUpdateController.text);
                      String model = nameUpdateController.text;
                      int matricula = int.parse(milesUpdateController.text);
                      int passatgers =
                          int.parse(passatgersUpdateController.text);
                      _update(id, model, matricula, passatgers);
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      controller: idDeleteController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Taxi id',
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Eliminar'),
                    onPressed: () {
                      int id = int.parse(idDeleteController.text);
                      _delete(id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _insert(model, matricula, passatgers) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnModel: model,
      DatabaseHelper.columnMatricula: matricula,
      DatabaseHelper.columnPassatger: passatgers,
    };
    Taxi taxis = Taxi.fromMap(row);
    final id = await dbHelper.insert(taxis);
    _showMessageInScaffold('inserir fila id: $id');
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    taxis.clear();
    allRows.forEach((row) => taxis.add(Taxi.fromMap(row)));
    _showMessageInScaffold('Busqueda feta.');
    setState(() {});
  }

  void _query(model) async {
    final allRows = await dbHelper.queryRows(model);
    nomtaxis.clear();
    allRows.forEach((row) => nomtaxis.add(Taxi.fromMap(row)));
  }

  void _update(id, model, matricula, passatgers) async {
    // row to update
    Taxi car = Taxi(id, model, matricula, passatgers);
    final rowsAffected = await dbHelper.update(car);
    _showMessageInScaffold('Actualitcació $rowsAffected fila(s)');
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    _showMessageInScaffold('eliminat $rowsDeleted fila(s): fila $id');
  }
}
