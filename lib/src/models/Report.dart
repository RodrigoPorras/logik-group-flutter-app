
import 'Document.dart';
import 'Record.dart';

class Report{
  String cliente;
  String ciudad;
  String numeroDeGuia;
  String fechaRecepcionDevolucion;
  String direccion;
  //no se usa extension de archivo para poder poner .png .xls  ol o que sea
  String nombreArchivoReporte;
  String nombreLaboratorio;

  bool hasImage = false;

  List<Document> documentsForThisReport = List<Document>();

  String tipo; //posibles opciones hasta ahora 'autorizacion','reporte'
  List<Record> recordsForThisAuth = List<Record>();

  Report({this.cliente, this.ciudad, this.numeroDeGuia,
      this.fechaRecepcionDevolucion, this.direccion, this.nombreArchivoReporte,
      this.nombreLaboratorio, this.documentsForThisReport,this.tipo,this.recordsForThisAuth});

  factory Report.fromJson(Map<String, dynamic> json){
    return Report(
      cliente: json['cliente'],
      ciudad: json['ciudad'],
      numeroDeGuia: json['numeroDeGuia'],
      fechaRecepcionDevolucion: json['fechaRecepcionDevolucion'],
      direccion: json['direccion'],
      nombreArchivoReporte: json['nombreArchivoReporte'],
      nombreLaboratorio: json['nombreLaboratorio'],

      documentsForThisReport: json['documentsForThisReport'] == null ? null : (json['documentsForThisReport'] as List).map((i)
        => Document.fromJson(i)).toList(),

      tipo: json['tipo'],
      recordsForThisAuth: json['recordsForThisAuth'] == null ? null : (json['recordsForThisAuth'] as List).map((j)
        => Record.fromJson(j)).toList(),

    );
  }

  Map<String, dynamic> toJson() => {
    'cliente' : cliente,
    'ciudad' : ciudad,
    'numeroDeGuia' : numeroDeGuia,
    'fechaRecepcionDevolucion' : fechaRecepcionDevolucion,
    'direccion' : direccion,
    'nombreArchivoReporte' : nombreArchivoReporte,
    'nombreLaboratorio' : nombreLaboratorio,
    'documentsForThisReport' : documentsForThisReport,
    'tipo' : tipo,
    'recordsForThisAuth' : recordsForThisAuth,
  };

}