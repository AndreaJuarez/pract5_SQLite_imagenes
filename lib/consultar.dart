import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'convertidor.dart';
import 'detalles.dart';
import 'insert.dart';
import 'delete.dart';
import 'update.dart';
import 'select.dart';
import 'consultar.dart';
import 'main.dart';

class Consultar extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Consultar> {

  //ELEMENTO PARA BUSQUEDA
  String searchString = "";
  bool _isSearching = false;
  
  Future<List<Student>> Studentss;
  var dbHelper;
  TextEditingController controller_busqueda = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _isSearching = false;
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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
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
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: _isSearching ? TextField(
          decoration: InputDecoration(
              hintText: "Buscando..."),
          onChanged: (value) {
            setState(() {
              searchString = value;
            });
          },
          controller: controller_busqueda,
        )
            :Text("SELECT REGISTRY BY MATRICULA",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: <Widget>[
          !_isSearching ? IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                searchString = "";
                this._isSearching = !this._isSearching;
              });
            },
          )
              :IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                this._isSearching = !this._isSearching;
              });
            },
          )
         ],
        ),
        body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: FutureBuilder(
            future: Studentss,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Cargando..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data[index].matricula.contains(controller_busqueda.text)
                        ? ListTile(
                            leading: CircleAvatar(
                              minRadius: 25.0,
                              maxRadius:  25.0,
                              backgroundColor: Colors.white,
                              backgroundImage: Convertir.imageFromBase64sString(snapshot.data[index].photoName).image,),
                            title: new Text(
                              snapshot.data[index].name.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: new Text(
                              snapshot.data[index].matricula.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context,
                                new MaterialPageRoute(builder: (context)=> DetailPage(snapshot.data[index])));
                            },
                          )
                        : Container();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
  }
