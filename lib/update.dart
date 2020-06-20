import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'insert.dart';
import 'delete.dart';
import 'select.dart';
import 'consultar.dart';
import 'main.dart';
import 'package:image_picker/image_picker.dart';
import 'convertidor.dart';

class Update extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Update> {
  //Variable referentes al manejo de la BD
  Future<List<Student>> Studentss;
  TextEditingController controller = TextEditingController();     //CONTROLER PARA CAMPO A ACTUALIZAR
  TextEditingController controller_photo = TextEditingController();

  //String photoName;
  String imagen;

  String name;
  String lastname1;
  String lastname2;
  String phone;
  String email;
  String matricula;

  int currentUserId;
  String valor;
  int opcion;


  String descriptive_text = "Student Name";

  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  bool change;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    change = true;
    refreshList();
  }

  //select
  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  void cleanData() {
    controller.text = "";
    controller_photo.text = "";
  }

  pickImagefromGallery(BuildContext context){
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile){
      String  imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagen = imgString;
      Navigator.of(context).pop();
      controller_photo.text = "Campo lleno";
      return imagen;
    });
  }

  pickImagefromCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagen = imgString;
      Navigator.of(context).pop();
      controller_photo.text = "Campo lleno";
      return imagen;
    });
  }

  //METODO PARA SELECCIONAR DE CAMARA O GALERIA
  Future<void> _seleccionar() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Choose an option:", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.grey[300],
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: Text("1. Gallery",
                      style: TextStyle(color: Colors.black),),
                    onTap: () {
                      pickImagefromGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10.0),),
                  GestureDetector(
                    child: Text("2. Camera",
                      style: TextStyle(color: Colors.black),),
                    onTap: () {
                      pickImagefromCamera(context);
                    },
                  )
                ]),
              ));
        });
  }
  void updateData(){
    print("Valor de Opción");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      //NOMBRE
      if (opcion==1) {
        Student stu = Student(currentUserId, valor, lastname1, lastname2, phone, email, matricula, imagen);
        dbHelper.update(stu);
      }
      //APELLIDO PATERNO
      else if (opcion==2) {
        Student stu = Student(currentUserId, name, valor, lastname2, phone, email, matricula, imagen);
        dbHelper.update(stu);
      }
      //APELLIDO MATERNO
      else if (opcion==3) {
        Student stu = Student(currentUserId, name, lastname1, valor, phone, email, matricula, imagen);
        dbHelper.update(stu);
      }
      //PHONE
      else if (opcion==4) {
        Student stu = Student(currentUserId, name, lastname1, lastname2, valor, email, matricula, imagen);
        dbHelper.update(stu);
      }
      //EMAIL
      else if (opcion==5) {
        Student stu = Student(currentUserId, name, lastname1, lastname2, phone, valor, matricula, imagen);
        dbHelper.update(stu);
      }
      //MATRICULA
      else if (opcion==6) {
        Student stu = Student(currentUserId, name, lastname1, lastname2, phone, email, valor, imagen);
        dbHelper.update(stu);
      }
      else if (opcion==7) {
        Student stu = Student(currentUserId, name, lastname1, lastname2, phone, email, matricula, valor);
        dbHelper.update(stu);
      }
      cleanData();
      refreshList();
    }
  }

  //Formulario
  Widget form() {
    return Form(
      key: formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 50.0),
            TextFormField(
              controller: change ? controller : controller_photo,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: descriptive_text),
              validator: (val) => change == false ? val.length == 0 ? 'Enter Data' : controller_photo.text != "Campo lleno"
                  ? "Solo se puede imagenes" : null : val.length == 0 ? 'Enter Data' : null,
              onSaved: (val) => change ? valor = controller.text : valor = imagen,
            ),
            SizedBox(height: 30,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  color: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue[900]),
                  ),
                  onPressed: updateData,
                  //child: Text(isUpdating ? 'Update ' : 'Add Data'),
                  child: Text('Update Data',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue[900]),
                  ),
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    cleanData();
                    refreshList();
                  },
                  child: Text("Cancel",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



//MOSTRAR DATOS
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
          DataColumn(
            label: Text("Fotografía"),
          ),
        ],
        rows: Studentss.map((student) =>
            DataRow(cells: [
              //NOMBRE 1
              DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Nombre";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  imagen= student.photoName;
                  opcion=1;
                });
                controller.text = student.name;
              }),
              //APELLIDO PATERNO 2
              DataCell(Text(student.lastname1.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Apellido Paterno";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  imagen= student.photoName;
                  opcion=2;
                });
                controller.text= student.lastname1;
              }),
              //APELLIDO MATERNO 3
              DataCell(Text(student.lastname2.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Apellido Materno";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  imagen = student.photoName;
                  opcion=3;
                });
                controller.text= student.lastname2;
              }),
              //TELEFONO 4
              DataCell(Text(student.phone.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Telefono";
                  name = student.name;
                  currentUserId = student.controlnum;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  imagen = student.photoName;
                  opcion=4;
                });
                controller.text = student.phone;
              }),
              //EMAIL 5
              DataCell(Text(student.email.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "E-mail";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  imagen = student.photoName;
                  opcion=5;
                });
                controller.text = student.email;
              }),
              //MATRICULA 6
              DataCell(Text(student.matricula.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Matricula";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone=student.phone;
                  email=student.email;
                  matricula = student.matricula;
                  imagen= student.photoName;
                  opcion=6;
                });
                controller.text = student.matricula;
              }),
              //FOTOGRAFIA
              DataCell(Convertir.imageFromBase64sString(student.photoName), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = false;
                  descriptive_text = "Imagen";
                  currentUserId = student.controlnum;
                  name = student.name;
                  lastname1 = student.lastname1;
                  lastname2 = student.lastname2;
                  phone = student.phone;
                  email = student.email;
                  matricula = student.matricula;
                  imagen = student.photoName;
                  opcion=7;
                });
                _seleccionar();
                controller_photo.text = "Campo lleno";
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
        automaticallyImplyLeading: true,
        title: Text('UPDATE DATA'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}