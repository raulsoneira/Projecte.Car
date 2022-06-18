import 'car.dart';
import 'package:flutter/material.dart';
import 'dbhelper.dart';
import 'package:projecte_car/car.dart';

void main() => runApp(const MyApp());
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

//----------------------MENU-----------------------


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(

          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Column(
                    children: [
                      Expanded(child:
                        Image.asset('assets/taxiii.gif')
                      ),
                      const Text("Taxi"),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Inserir'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const inserir()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Buscar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const buscar()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Actualitzar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const actualitzar()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Eliminar'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const eliminar()),
                    );
                  },
                ),
              ],
            ),

          )
      ),
    );

  }
}

//----------------------INSERIR-----------------------

class inserir extends StatelessWidget {
  const inserir({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '_title',
        home: Scaffold(
        /*appBar: AppBar(title: const Text(_title)),*/
    body: const inserirTaxi(),
    ),
    );
  }
}

class inserirTaxi extends StatefulWidget {
  const inserirTaxi({Key? key}) : super(key: key);

  @override
  State<inserirTaxi> createState() => _inserirTaxiState();
}

class _inserirTaxiState extends State<inserirTaxi> {
  List<Taxi> taxis = [];
  List<Taxi> nomtaxis = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController milesController = TextEditingController();
  TextEditingController passatgersController = TextEditingController();



  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
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

}

//----------------------BUSCAR-----------------------
class buscar extends StatelessWidget {
  const buscar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '_title',
      home: Scaffold(
        /*appBar: AppBar(title: const Text(_title)),*/
        body: const buscarTaxi(),
      ),
    );
  }
}

class buscarTaxi extends StatefulWidget {
  const buscarTaxi({Key? key}) : super(key: key);

  @override
  State<buscarTaxi> createState() => _buscarTaxiState();
}

class _buscarTaxiState extends State<buscarTaxi> {
  List<Taxi> taxis = [];
  List<Taxi> nomtaxis = [];

  TextEditingController queryController = TextEditingController();



  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
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
    );
  }
  void _query(model) async {
    final allRows = await dbHelper.queryRows(model);
    nomtaxis.clear();
    allRows.forEach((row) => nomtaxis.add(Taxi.fromMap(row)));
  }
}

//----------------------ACTUALITZAR-----------------------
class actualitzar extends StatelessWidget {
  const actualitzar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '_title',
      home: Scaffold(
        /*appBar: AppBar(title: const Text(_title)),*/
        body: const actualitzarTaxi(),
      ),
    );
  }
}

class actualitzarTaxi extends StatefulWidget {
  const actualitzarTaxi({Key? key}) : super(key: key);

  @override
  State<actualitzarTaxi> createState() => _actualitzarTaxiState();
}

class _actualitzarTaxiState extends State<actualitzarTaxi> {
  List<Taxi> taxis = [];
  List<Taxi> nomtaxis = [];

  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController milesUpdateController = TextEditingController();
  TextEditingController passatgersUpdateController = TextEditingController();


  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
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
    );
  }

  void _update(id, model, matricula, passatgers) async {
    // row to update
    Taxi taxi = Taxi(id, model, matricula, passatgers);
    final rowsAffected = await dbHelper.update(taxi);
    _showMessageInScaffold('Actualitcació $rowsAffected fila(s)');
  }
}


//----------------------ELIMINAR-----------------------
class eliminar extends StatelessWidget {
  const eliminar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '_title',
      home: Scaffold(
        /*appBar: AppBar(title: const Text(_title)),*/
        body: const eliminarTaxi(),
      ),
    );
  }
}

class eliminarTaxi extends StatefulWidget {
  const eliminarTaxi({Key? key}) : super(key: key);

  @override
  State<eliminarTaxi> createState() => _eliminarTaxiState();
}

class _eliminarTaxiState extends State<eliminarTaxi> {
  List<Taxi> taxis = [];
  List<Taxi> nomtaxis = [];

  TextEditingController idDeleteController = TextEditingController();


  final dbHelper = DatabaseHelper.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
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
    );
  }

  void _delete(id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.delete(id);
    _showMessageInScaffold('eliminat $rowsDeleted fila(s): fila $id');
  }
}
