import 'dart:convert';
import 'dart:io';
import 'package:logik_groupv3/src/hotData/HotData.dart';
import 'package:logik_groupv3/src/models/Report.dart';
import 'package:logik_groupv3/src/models/Reports.dart';
import 'package:path_provider/path_provider.dart';

class JSONManager {

  /*static File jsonFile;
  static Directory dir;
  static String fileName = "reportes.json";
  static bool fileExists = false;
  static List<dynamic> fileContent;

  static void initializeJSONFiles(){
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists){
        fileContent = json.decode(jsonFile.readAsStringSync());
      }
    });
  }*/


  static void createJSON(Reports reports) {

    print("Creating json file in path: " + (HotData.dir.path + "/" + HotData.fileName));

    File file = new File(HotData.dir.path + "/" + HotData.fileName);
    file.createSync();

    file.writeAsStringSync(json.encode(reports.toJson()));
  }

  static void addReportToJSON(Report report) {
    print("Writing to json file!");

    List<dynamic> jsonFileContent = json.decode(HotData.jsonFile.readAsStringSync());

    jsonFileContent.add(report.toJson());

    HotData.jsonFile.writeAsStringSync(json.encode(jsonFileContent));

  }

  static void updateFile(Reports reports) {
    print("updating file..!");
    File file = new File(HotData.dir.path + "/" + HotData.fileName);
    file.createSync();

    file.writeAsStringSync(json.encode(reports.toJson()));

    print("saved!" + json.encode(reports.toJson()));
  }

  /*static void writeToFile(Reports reports) {
    print("Writing to file!");

    if (fileExists) {
      print("File exists");

      List<dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());

      jsonFileContent.add(reports.toJson());

      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(reports, dir, fileName);
    }

    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(' Saved ' + fileContent.toString());
  }*/

}
