import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'insert.dart';
import 'delete.dart';
import 'update.dart';
import 'select.dart';
import 'consultar.dart';
import 'main.dart';

class Select extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Select> {
  Future<List<Student>> Studentss;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_lastname1 = TextEditingController();
  TextEditingController controller_lastname2 = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_email= TextEditingController();
  TextEditingController controller_matricula = TextEditingController();
  TextEditingController controller_busqueda = TextEditingController();

  String name;
  String lastname1;
  String lastname2;
  String phone;
  String email;
  String matricula;
  String search;

  int currentUserId;

  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.Busqueda(controller_busqueda.text);
    });
  }

  void cleanData() {
    controller_busqueda.text = "";
  }


//SHOW DATA
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Nombre"),
          ),
          DataColumn(
            label: Text("A. Paterno"),
          ),
          DataColumn(
            label: Text("A. Materno"),
          ),
          DataColumn(
            label: Text("Telefono"),
          ),
          DataColumn(
            label: Text("Email"),
          ),
          DataColumn(
            label: Text("Matricula"),
          ),
        ],
        rows: Studentss.map((student) =>
            DataRow(cells: [
              //NOMBRE
              DataCell(Text(student.name.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_name.text = student.name;
                  }),
              //APELLIDO PATERNO
              DataCell(Text(student.lastname1.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_lastname1.text= student.lastname1;
                  }),
              //APELLIDO MATERNO
              DataCell(Text(student.lastname2.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_lastname2.text= student.lastname2;
                  }),
              //TELEFONO
              DataCell(Text(student.phone.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      name = student.name;
                    });
                    controller_phone.text = student.phone;
                  }),
              //EMAIL
              DataCell(Text(student.email.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_email.text = student.email;
                  }),
              //MATRICULA
              DataCell(Text(student.matricula.toString().toUpperCase()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      currentUserId = student.controlnum;
                    });
                    controller_matricula.text = student.matricula;
                  }),
            ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data founded!");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomInset: false,   //new line
       endDrawer: Drawer(
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
      appBar: AppBar(
        title: isUpdating ? TextField(
            //autofocus: true,
            controller: controller_busqueda,
            onChanged: (text){
              refreshList();
            })
            : Text("SELECT DATA BY MATRICULA"),
        leading: IconButton(
          icon: Icon(isUpdating ? Icons.done: Icons.search),
          onPressed: () {
            print("Is typing" + isUpdating.toString());
            setState(() {
              isUpdating = !isUpdating;
              //refreshList();
              controller_busqueda.text = "";
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //form(),
            list(),
          ],
        ),
      ),
    );
  }
}