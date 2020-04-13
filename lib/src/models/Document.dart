import 'Record.dart';
class Document{
  String numeroDocCliente = '';
  String fecha = '';
  String imagePathName;


  List<Record> recordsForThisDocClient = List<Record>();

  bool hasImage = false;

  int numReferenciasRegistradas = 0;
  int numProductosRegistrados = 0;

  Document({this.numeroDocCliente, this.recordsForThisDocClient,this.fecha,this.imagePathName});

  factory Document.fromJson(Map<String, dynamic> json){

    return Document(
      numeroDocCliente: json['numeroDocCliente'],
      recordsForThisDocClient: json['recordsForThisDocClient'] != null ? (json['recordsForThisDocClient']  as List).map((i)
        => Record.fromJson(i)).toList() : null,
      fecha: json['fecha'],
      imagePathName: json['imagePathName']
    );
  }

  Map<String, dynamic> toJson() => {
    'numeroDocCliente' : numeroDocCliente,
    'recordsForThisDocClient' : recordsForThisDocClient,
    'fecha' : fecha,
    'imagePathName' : imagePathName
  };
}