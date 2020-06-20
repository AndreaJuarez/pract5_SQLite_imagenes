class Student{
  //CAMPOS
  int controlnum;
  String name;
  String lastname1;
  String lastname2;
  String phone;
  String email;
  String matricula;
  String photoName;


  //CONSTRUCTOR
  Student (this.controlnum, this.name, this.lastname1, this.lastname2, this.phone, this.email, this.matricula, this.photoName);

  //MAPEO
  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      'controlnum': controlnum,
      'name': name,
      'lastname1': lastname1,
      'lastname2': lastname2,
      'phone': phone,
      'email': email,
      'matricula': matricula,
      'photoName': photoName,
    };
    return map;
  }

  Student.fromMap(Map<String,dynamic> map){
    controlnum = map['controlnum'];
    name = map['name'];
    lastname1 = map['lastname1'];
    lastname2 = map['lastname2'];
    phone = map['phone'];
    email = map['email'];
    matricula = map['matricula'];
    photoName = map['photoName'];
  }
}