import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'convertidor.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatelessWidget{

  final Student student;
  DetailPage(this.student);

  TextEditingController controller_photo = TextEditingController();
  String imagen;

  pickImagefromGallery(BuildContext context){
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile){
      String  imgString = Convertir.base64String(imgFile.readAsBytesSync());
        imagen = imgString;
        Navigator.of(context).pop();
        return imagen; 
    });
  }

  pickImagefromCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
        imagen = imgString;
        Navigator.of(context).pop();
        return imagen; 
    });
  }

    //METODO PARA SELECCIONAR DE CAMARA O GALERIA
  Future<void> _seleccionar(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose an option:", textAlign: TextAlign.center,style: TextStyle(color:Colors.black),),
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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("USER DATA"),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: Container(
          width: 700,
          height: 800,
                color: Colors.grey[850],
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 100.0,
                        ),
                        //FOTOGRAFIA
                        CircleAvatar(
                          radius: 85,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                              minRadius: 80.0,
                              maxRadius:  80.0,
                              backgroundColor: Colors.white,
                              backgroundImage: Convertir.imageFromBase64sString(student.photoName).image,
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("         "),
                            FloatingActionButton(
                            onPressed: () {
                              _seleccionar(context);
                            },
                            child: Icon(Icons.person),
                            backgroundColor: Colors.white,
                          ),
                          ],
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("   Datos de Usuario",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                        new Divider(
                            color: Colors.blue[900],
                            indent: 20,
                            endIndent: 20,
                            thickness: 3.0),
                        new Padding(padding: EdgeInsets.all(15.0),),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                        //NOMBRE
                        Text(
                          student.name.toString(),
                          style: TextStyle(
                              fontSize: 25.0,
                              //fontWeight: FontWeight.bold
                          ),
                        ),
                        //APELLIDO PATERNO
                        Text(
                          student.lastname1.toString(),
                          style: TextStyle(
                              fontSize: 25.0,
                              //fontWeight: FontWeight.bold
                          ),
                        ),
                        //APELLIDO MATERNO
                        Text(
                          student.lastname2.toString(),
                          style: TextStyle(
                              fontSize: 25.0,
                              //fontWeight: FontWeight.bold
                          ),
                        ),
                          ],
                        ),
                        //MATRICULA
                      new Padding(padding: EdgeInsets.all(10.0),),
                      Chip(
                        backgroundColor: Colors.blue[900],
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal:60),
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.list),
                        ),
                        label: Text('Matricula: ${student.matricula}'),
                      ),
                      new Padding(padding: EdgeInsets.all(10.0),),
                      Chip(
                        backgroundColor: Colors.blue[900],
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal:60),
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.email),
                        ),
                        label: Text('E-mail: ${student.email}'),
                      ),
                      new Padding(padding: EdgeInsets.all(10.0),),
                      Chip(
                        backgroundColor: Colors.blue[900],
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal:60),
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.phone),
                        ),
                        label: Text('Telefono: ${student.phone}'),
                      ),
                      SizedBox(
                          height: 170.0,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            );
  }
}