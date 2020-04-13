import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/hotData/HotData.dart';
import 'package:path_provider/path_provider.dart';




class MyFirebase{

  static  Future uploadFilesOld(BuildContext context) async {

    var  getDir  = await getApplicationDocumentsDirectory();
    final String path = getDir.path + '/myData';

    List<StorageUploadTask> allUploadTask = new List<StorageUploadTask>();


    for(var report in HotData.allReports){

      String fileNameRep = report.nombreArchivoReporte +'.png'; //imagen del reporte
      final File imageRep = File(path+'/'+fileNameRep);

      if(imageRep != null){
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(report.nombreLaboratorio+'/'+report.numeroDeGuia+'/'+fileNameRep);
        StorageUploadTask uploadTaskReport = firebaseStorageRef.putFile(imageRep);
        allUploadTask.add(uploadTaskReport);
      }

      for(var doc in report.documentsForThisReport){
        String fileNameDoc = doc.imagePathName +'.png'; //imagen del documento

        final File imageDoc = File(path+'/'+fileNameDoc);

        if(imageDoc == null) continue;

        //String fileName = basename(doc.imagePathName);

        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(report.nombreLaboratorio+'/'+report.numeroDeGuia+'/'+fileNameDoc);
        StorageUploadTask uploadTaskDoc = firebaseStorageRef.putFile(imageDoc);

        allUploadTask.add(uploadTaskDoc);

        print("Subiendo"  + fileNameDoc);
      }

    }



   // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print("Se ha subido todo");
    //aqui acciones para luego de que subieron los archivos
  }
}