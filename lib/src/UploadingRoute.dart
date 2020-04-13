import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:logik_groupv3/src/hotData/HotData.dart';
import 'package:logik_groupv3/src/widgets/UploadTaskLoadingList.dart';
import 'package:path_provider/path_provider.dart';

class UploadingRouteState extends State<UploadingRoute> {
  List<StorageUploadTask> allUploadTask = new List<StorageUploadTask>();
  bool hasUploaded = false;

  final List<Widget> children = <Widget>[];

  Future uploadFiles(BuildContext context) async {
    var getDir = await getApplicationDocumentsDirectory();
    final String path = getDir.path + '/myData';


    for (var report in HotData.allReports) {
      String fileNameRep =
          report.nombreArchivoReporte + '.png'; //imagen del reporte
      final File imageRep = File(path + '/' + fileNameRep);

      if (await imageRep.exists()) {
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child(report.nombreLaboratorio +
                '/' +
                report.numeroDeGuia +
                '/' +
                fileNameRep);
        StorageUploadTask uploadTaskReport =
            firebaseStorageRef.putFile(imageRep);
        allUploadTask.add(uploadTaskReport);
        print("Subiendo " + fileNameRep);
      }

      if(report.documentsForThisReport == null ) continue; //si no hay reportes continuo al otro reporte

      for (var doc in report.documentsForThisReport) {
        String fileNameDoc = doc.imagePathName + '.png'; //imagen del documento

        final File imageDoc = File(path + '/' + fileNameDoc);

        bool exist = await imageDoc.exists();
        if (!exist) continue;

        //String fileName = basename(doc.imagePathName);

        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child(report.nombreLaboratorio +
                '/' +
                report.numeroDeGuia +
                '/' +
                fileNameDoc);
        StorageUploadTask uploadTaskDoc = firebaseStorageRef.putFile(imageDoc);

        allUploadTask.add(uploadTaskDoc);
        print("Subiendo" + fileNameDoc);
      }
    }

    // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    //aqui acciones para luego de que subieron los archivos

    setState(() {
      children.clear();

      if(allUploadTask.length == 0){
        //cuando no hay fotos por subir subo solo el documento json
        uploadJSON(context);
      }


      allUploadTask.forEach((StorageUploadTask task) {
        final Widget tile = UploadTaskLoadingList(
          task: task,
          onUploaded: () {
            allUploadTask.remove(task);
            if (allUploadTask.length == 0) {
              print("Se han subido todas las fotos!, subiendo json");
              //subir json
              uploadJSON(context);
            }
          },
        );
        children.add(tile);
      });
    }); //actualiza los valores de la lista en el alert dialog
  }

  Future uploadJSON(BuildContext context) async {
    var getDir = await getApplicationDocumentsDirectory();
    final String path = getDir.path + '/myData';
    String fileNameJSON = 'reportes.json'; //imagen del reporte

    final File JSONFile = File(path + '/' + fileNameJSON);

    if (JSONFile != null) {
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('JSON/' +
              HotData.uniqueId +
              '-' +
              DateFormat("dd-MM-yyyy").format(DateTime.now()) +
              '.json');
      StorageUploadTask uploadTaskReport = firebaseStorageRef.putFile(JSONFile);
      StorageTaskSnapshot taskSnapshot = await uploadTaskReport.onComplete;
      setState(() {
        print('Cantidad de archivos : ' + Directory(getDir.path+ '/myData').listSync().length.toString());
        for(var file in  Directory(getDir.path+ '/myData').listSync(recursive: true)){
          print('Encontrado!: '+file.path);
          file.deleteSync(recursive: true);
        }

        HotData.allReports  = [];
        HotData.reportsContent  = null;
        HotData.updateAll();
        hasUploaded = true;
      });
    } else {
      print('El archivo es nulo');
    }
  }

  @override
  void initState() {
    print('init state subir a firebase');
    uploadFiles(context);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(hasUploaded ? 'Envio Exitoso!':'Subiendo Archivos',textAlign: TextAlign.center,),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
        Container(
          width: 200,
          height: 2,
          color: hasUploaded ?  Colors.green : Colors.red,
        ),
        Divider(
          color: Colors.white,
        ),
        Container(
          width: double.maxFinite,
          height: 300.0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (BuildContext context, int index) {
              return children[index];
            },
          ),
         /* child: ListView(
            children: children,
          )*/
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: RaisedButton(
            child: Text("Aceptar"),
            onPressed: () {
              HotData.updateAll();
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );

    /*
    *  width: 100,
          height: 100,
          child:
              hasUploaded ? Container(
                  child: Text(
                    'Se Ha Subido Todo!',
                  )
              ): ListView(
                children: children,
              ),
    * */
  }
}

class UploadingRoute extends StatefulWidget {
  @override
  UploadingRouteState createState() => UploadingRouteState();
}
