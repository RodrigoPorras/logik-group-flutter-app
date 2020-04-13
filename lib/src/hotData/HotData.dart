import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/models/Document.dart';
import 'package:logik_groupv3/src/models/Report.dart';
import 'package:logik_groupv3/src/models/Reports.dart';
import 'package:logik_groupv3/src/util/JSONManager.dart';
import 'package:path_provider/path_provider.dart';

class HotData {

  static File jsonFile;
  static Directory dir;
  static String fileName = "reportes.json";
  static bool fileExists = false;
  static List<dynamic> reportsContent;

  static StreamController<int> streamController = StreamController.broadcast();
  static List<Report> allReports = [];

  static List<String> motivos = List<String>();

  static Map<String,String> legrandDB  = Map<String,String>();
  static Map<String,String> lasanteDB  = Map<String,String>();
  static Map<String,String> percosDB  = Map<String,String>();

  static String currentLab;

  static List<String> clients;

  static String uniqueId = 'sinUniqueID';


  //new  Directory(dir.path + '/myData').createSync(recursive: false);

  static void LoadReportsInfo() {

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = Directory(directory.path + '/myData');
      print('directoio'+dir.path);
      //verifico si la caprte de datos esta creada, sino la creo
      if(!Directory(dir.path).existsSync()){
        new Directory(dir.path).createSync(recursive: false);
        print('Directorio de data creado porque no existia');
      }


      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();

      print('existe? '+fileExists.toString());

      if (fileExists){

        reportsContent = json.decode(jsonFile.readAsStringSync());
        allReports = Reports.fromJson(reportsContent).allReports;

        for(var report in allReports){
          print('Directorio donde se busca imagen: '+dir.path + "/" + report.nombreArchivoReporte + '.png');

          String dirForSearchR = dir.path + "/" + report.nombreArchivoReporte;

          bool exist = FileSystemEntity.typeSync(dirForSearchR + '.png') != FileSystemEntityType.notFound;

          report.hasImage = exist;

          if(report.documentsForThisReport == null)
            continue;

          for(var doc in report.documentsForThisReport){
            bool docImageExist = FileSystemEntity.typeSync(dirForSearchR + '-' + doc.numeroDocCliente + '.png') != FileSystemEntityType.notFound;
            doc.hasImage = docImageExist;
          }
        }

        streamController.add(1);
      }
    });
  }



  static void saveNewDocument(int indexReport, Document newDoc){
    if( HotData.allReports[indexReport].documentsForThisReport == null)
      HotData.allReports[indexReport].documentsForThisReport = List<Document>();

    HotData.allReports[indexReport].documentsForThisReport.add(newDoc);
    HotData.saveAll();
  }

  static void saveAll(){
    JSONManager.updateFile(Reports( allReports: allReports));
    updateAll();
  }

  static void loadMotivos(BuildContext context){
    getMotivosDevolucionTxt(context).then((data) {
      motivos = data.split('\n');
      print('Motivos Cargados' + motivos.length.toString());
    });
  }

  static Future<String> getMotivosDevolucionTxt(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/textFiles/motivos.txt');
  }

  static void loadAllLaboratoriesDB(BuildContext context) async {
    var dataLegrand = await DefaultAssetBundle.of(context).loadString('assets/textFiles/legrandDB.txt');
    var dataLasante = await DefaultAssetBundle.of(context).loadString('assets/textFiles/lasanteDB.txt');
    var dataPercos = await DefaultAssetBundle.of(context).loadString('assets/textFiles/percosDB.txt');

    print('valor temp : '+ dataLegrand.split('\n')[3].split('\t')[1]);

    legrandDB = Map.fromEntries(dataLegrand.split('\n').map((n) => MapEntry(n.split('\t')[0], n.replaceAll(n.split('\t')[0]+'\t', ''))));
    lasanteDB = new Map.fromIterable(dataLasante.split('\n'), key: (v) => v.split('\t')[0], value: (v) => v.replaceAll(v.split('\t')[0]+'\t', ''));
    percosDB = new Map.fromIterable(dataPercos.split('\n'), key: (v) => v.split('\t')[0], value: (v) => v.replaceAll(v.split('\t')[0]+'\t', ''));

    print('legrand productos Cargados' + legrandDB.length.toString());

    //percosDB.forEach((k,v) => print('${k +' valor--> '}: ${v}'));

    print('lasante productos cargados' + lasanteDB.length.toString());
    print('percos productos Cargados' + percosDB.length.toString());
  }

  static void getClientsFormTxt(BuildContext context) async {
     var data = await DefaultAssetBundle.of(context)
        .loadString('assets/textFiles/nombreClientes.txt');

      clients = data.split('\n');
  }

  static void updateAll(){
    streamController.add(1);
  }

  static void getId(BuildContext context) async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueId = androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}