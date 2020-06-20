import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'convertidor.dart';
import 'insert.dart';
import 'delete.dart';
import 'update.dart';
import 'select.dart';
import 'consultar.dart';
import 'main.dart';

class Insert extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Insert> {
  //VARIABLES REFERENTES AL MANEJO DE LA BD
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Student>> Studentss;

  //CONTROLLERS
  TextEditingController controller_photo = TextEditingController();
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_lastname1 = TextEditingController();
  TextEditingController controller_lastname2 = TextEditingController();
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_email = TextEditingController();
  TextEditingController controller_matricula = TextEditingController();
  
  int currentUserId;
  String name;
  String lastname1;
  String lastname2;
  String phone;
  String email;
  String matricula;
  String photoName;

  String imagen;   //VARIABLE PARA GUARDAR IMGSTRING

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating; //PARA SABER ESTADO ACTUAL DE LA CONSULTA

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
    controller_name.text = "";
    controller_lastname1.text = "";
    controller_lastname2.text = "";
    controller_phone.text = "";
    controller_email.text = "";
    controller_matricula.text = "";
    controller_photo.text = "";
  }

  void dataValidate() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Student stu = Student(
            currentUserId, name, lastname1, lastname2, phone, email, matricula, imagen);
        //dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu =
        Student(
            null, name, lastname1, lastname2, phone, email, matricula, imagen);

        //VALIDACION PARA REGISTRO DE DATOS
        var validation = await dbHelper.ValidarInsert(stu);
        print(validation);
        if (validation) {
          dbHelper.insert(stu);
          final snackBar = SnackBar(
            backgroundColor: Colors.green,
            content: Text('Datos ingresados correctamente!'),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text('Esta matricula ya existe, inténtalo de nuevo!'),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }

      //LIMPIA DESPUES DE EJECUTAR LA CONSULTA
      cleanData();
      refreshList();
    }
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
  Future<void> _seleccionar(BuildContext context) {
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


  @override
  //FORMULARIO
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        title: Text('INSERT DATA'),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                new SizedBox(height: 10.0),
                //TEXT FIELD PARA DATOS DEL FORMULARIO
                TextFormField(
                  controller: controller_photo,
                  decoration: InputDecoration(
                    labelText: "Subir una imagen",
                    suffixIcon: FloatingActionButton(
                      onPressed: () {
                        _seleccionar(context);
                      },
                    child: Icon(Icons.camera_alt),
                      backgroundColor: Colors.white,
                ),),
                  validator: (val) => val.length == 0 
                  ? "Ingrese una imagen por favor" 
                  : controller_photo.text == "Campo lleno" 
                  ? null : "Solo imagenes",
                ),
                TextFormField(
                  controller: controller_name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Nombre"),
                  validator: (val) =>
                  val.length == 0
                      ? 'Por favor inténtelo de nuevo'
                      : null,
                  onSaved: (val) => name = val,
                ),
                TextFormField(
                  controller: controller_lastname1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Apellido Paterno"),
                  validator: (val) =>
                  val.length == 0
                      ? 'Por favor inténtelo de nuevo'
                      : null,
                  onSaved: (val) => lastname1 = val,
                ),
                TextFormField(
                  controller: controller_lastname2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Apellido Materno"),
                  validator: (val) =>
                  val.length == 0
                      ? 'Por favor inténtelo de nuevo'
                      : null,
                  onSaved: (val) => lastname2 = val,
                ),
                TextFormField(
                  controller: controller_email,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "E-mail"),
                  validator: (val) =>
                  !val.contains('@')
                      ? 'Correo incorrecto, inténtalo de nuevo'
                      : null,
                  onSaved: (val) => email = val,
                ),
                TextFormField(
                  controller: controller_phone,
                  textCapitalization: TextCapitalization.characters,
                  //******************* CHECAR *****************
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Telefono"),
                  validator: (val) =>
                  val.length == 0
                      ? 'Por favor inténtelo de nuevo'
                      : null,
                  onSaved: (val) => phone = val,
                ),
                TextFormField(
                  controller: controller_matricula,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Matricula"),
                  validator: (val) =>
                  val.length == 0
                      ? 'Por favor inténtelo de nuevo'
                      : null,
                  onSaved: (val) => matricula = val,
                ),
                SizedBox(height: 30),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blue[900]),
                      ),
                      onPressed: dataValidate,
                      //SI ESTA LLENO ACTUALIZAR, SI NO AGREGAR
                      child: Text(isUpdating ? 'Update' : 'Add Data',
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
        ),
      ),
     );
  }

}
