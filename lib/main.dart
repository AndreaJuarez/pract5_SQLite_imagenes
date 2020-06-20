import 'package:act5_sqlite/convertidor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'student.dart';
import 'crud_operations.dart';
import 'dart:async';
import 'insert.dart';
import 'delete.dart';
import 'update.dart';
import 'select.dart';
import 'consultar.dart';

void main() => runApp(MaterialApp(
  home:new MyApp(),
  theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Carter'),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Carter'),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  Future<List<Student>> Studentss;

  TextEditingController controller_photo = TextEditingController();
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_lastname1 = TextEditingController();
  TextEditingController controller_lastname2 = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_email = TextEditingController();
  TextEditingController controller_matricula = TextEditingController();

  String photoName;
  String name;
  String lastname1;
  String lastname2;
  String email;
  String phone;
  String matricula;
  int currentUserId;

  var dbHelper;
  bool isUpdating;
  final formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  void cleanData() {
    controller_photo.text = "";
    controller_name.text = "";
    controller_lastname1.text = "";
    controller_lastname2.text = "";
    controller_phone.text = "";
    controller_email.text = "";
    controller_matricula.text = "";
  }

  //MOSTRAR DATOS
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Name"),
          ),
          DataColumn(
            label: Text("A. Paterno"),
          ),
          DataColumn(
            label: Text("A. Materno"),
          ),
          DataColumn(
            label: Text("E-mail"),
          ),
          DataColumn(
            label: Text("Telefono"),
          ),
          DataColumn(
            label: Text("Matricula"),
          ),
          /*
          DataColumn(
            label: Text("Delete"),
          ),*/
        ],
        rows: Studentss.map((student) => DataRow(cells: [
          //DataCell(Text(student.controlnum.toString())),
          DataCell(Text(student.name.toString().toUpperCase())),
          DataCell(Text(student.lastname1.toString().toUpperCase())),
          DataCell(Text(student.lastname2.toString().toUpperCase())),
          DataCell(Text(student.email.toString().toUpperCase())),
          DataCell(Text(student.phone.toString().toUpperCase())),
          DataCell(Text(student.matricula.toString().toUpperCase())),
          /*DataCell(Convertir.imageFromBase64sString(student.photoName),
          DataCell(IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              dbHelper.delete(student.controlnum);
              refreshList();
            },
          ))
        )*/
            ]
          )
        ).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //MENU LATERAL
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imagen.jpg"),
                      fit: BoxFit.cover
                  )
              ),
              padding: EdgeInsets.all(60),
              child: Text("   OPERATIONS:",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text("Home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context)
                        => new homePage()
                    ));
              },),
            ListTile(
              leading: Icon(Icons.add_to_photos, color: Colors.blue[500]),
              title: Text("Insert Data",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context)
                        => new Insert()
                    ));
              },),
            ListTile(
              leading: Icon(Icons.update, color: Colors.grey[500]),
              title: Text("Update Data",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context)
                        => new Update()
                    ));
              },),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.cyan[500]),
              title: Text("Delete Data",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context)
                        => new Delete()
                    ));
              },),
            ListTile(
              leading: Icon(Icons.youtube_searched_for, color: Colors.grey[300]),
              title: Text("Select Data",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context)
                        => new Select()
                    ));
              },),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text("Select Registry",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(
                        builder: (context)
                        => new Consultar()
                    ));
              },)
          ],
        ),
      ),
      appBar: new AppBar(
        title: Text("FLUTTER BASIC SQL OPERATIONS"),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: new Container(
        child: new Padding(
            padding: EdgeInsets.all(20.0),
            child: new Column(
                children: <Widget>[
                  list(),
                  MaterialButton(
                    color: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue[900]),
                    ),
                    onPressed: (){
                      refreshList();
                    },
                    //SI ESTA LLENO ACTUALIZAR, SI NO AGREGAR
                    child: Text('Actualizar',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
}
