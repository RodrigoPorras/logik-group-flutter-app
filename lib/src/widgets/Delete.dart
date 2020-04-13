import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/hotData/HotData.dart';
import 'package:logik_groupv3/src/models/Document.dart';
import 'package:logik_groupv3/src/models/Record.dart';
import 'package:logik_groupv3/src/models/Report.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;


class Delete extends StatelessWidget {
  List<Record> currentListRecords;
  Record recordToDelete;

  List<Document> currentListDocuments;
  Document documentToDelete;

  Report reportToDelete;

  String messageTitleToShow;
  String messageDescriptionToShow;

  Delete.fromRecord(this.currentListRecords,this.recordToDelete){
    messageTitleToShow = 'Eliminar Este Producto?';
    messageDescriptionToShow = recordToDelete.descripcionDelProducto;
  }
  Delete.fromAuthorization(this.reportToDelete){
    messageTitleToShow = 'Eliminar Esta Autorizacion?';
    messageDescriptionToShow = reportToDelete.cliente;
  }
  Delete.fromDocument(this.currentListDocuments,this.documentToDelete){
    messageTitleToShow = 'Eliminar Este Documento?';
    messageDescriptionToShow = documentToDelete.numeroDocCliente;

  }
  Delete.fromReport(this.reportToDelete){
    messageTitleToShow = 'Eliminar Este Reporte?';
    messageDescriptionToShow = reportToDelete.cliente;

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(messageTitleToShow),
      content: new Text(messageDescriptionToShow),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          child: new Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("Eliminar"),
          onPressed: () {
            if(recordToDelete != null){
              currentListRecords.remove(recordToDelete);

            }else if(documentToDelete != null){
              currentListDocuments.remove(documentToDelete);
              if(documentToDelete.hasImage)
                deletePhoto(documentToDelete.imagePathName);

            }else if(reportToDelete != null){
              HotData.allReports.remove(reportToDelete);
              if(reportToDelete.hasImage)
                deletePhoto(reportToDelete.nombreArchivoReporte);
            }
            HotData.saveAll();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }


  void deletePhoto  (String fileImageName) async{

    var  dir  = await getApplicationDocumentsDirectory();

    final finalPath = join(dir.path+ '/myData','$fileImageName.png',);

    var imageToDelete =  File(finalPath);

    bool exist = await imageToDelete.exists();
    if(exist){
      print('Borrando imagen...');
      imageToDelete.delete();
      HotData.updateAll();
    }

  }

}
