import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logik_groupv3/src/hotData/HotData.dart';
import 'package:logik_groupv3/src/models/Document.dart';
import 'package:logik_groupv3/src/models/Report.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:edge_detection/edge_detection.dart';

import 'package:flutter/services.dart';
import 'package:christian_picker_image/christian_picker_image.dart';

class TakePictureScreen extends StatelessWidget {
  File _image;
  Report reportToImage;
  Document documentToImage;
  String fileImageName;

  bool canShowPhoto = false;

  TakePictureScreen.fromReport(this.reportToImage){
    fileImageName = reportToImage.nombreArchivoReporte;
    canShowPhoto = reportToImage.hasImage;
  }

  TakePictureScreen.fromDocument(this.documentToImage){
    fileImageName = documentToImage.imagePathName;
    canShowPhoto = documentToImage.hasImage;
  }

  var globalContext;


  Future openCamera() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.camera);
    String imagePath;

    try {
      imagePath = await EdgeDetection.detectEdge;
    } on PlatformException {
      print( 'Failed to get cropped image path.');
    }

    if(imagePath != null){
      print("Diferente de nulo el path de la imagen");
      _image = new File(imagePath);//image;
    }

    if(_image != null){
      savePhoto(_image);
    }
  }

  Future selectPhoto() async {
    var gallery = await ImagePicker.pickImage(source: ImageSource.gallery,);
   // var gallery = await ChristianPickerImage.pickImages(maxImages: 1);

    //_image = gallery[0];
    _image = gallery;

    if(_image != null){
      savePhoto(_image);
    }
  }

  void savePhoto  (File image) async{
    Navigator.pop(globalContext);

    // getting a directory path for saving
    var  getDir  = await getApplicationDocumentsDirectory();
    final String path = getDir.path + '/myData';

    // copy the file to a new path
    final File newImage = await image.copy('$path/$fileImageName.png');

    /*
      setState(() {
        _image = newImage;
      });*/
    print('Imagen Guardada en: '+'$path/$fileImageName.png');

    if(documentToImage != null)
      documentToImage.hasImage = true;
    else
      reportToImage.hasImage = true;

    //borrando la imagen tomada por el plugin
    final dir = Directory(image.path);
    dir.deleteSync(recursive: true);

    HotData.updateAll();
  }

  static void renamePhoto(String fileImageName, String newFileNameName) async {
      try {
        print('Se intenta editar el nombre de una foto');
        var dir = await getApplicationDocumentsDirectory();

        final path = join(dir.path+ '/myData' ,'$fileImageName.png',);
        final newPath = join(dir.path+ '/myData','$newFileNameName.png');

        await File(path).rename(newPath);

      } catch (e) {
        print(e);
      }
      HotData.updateAll();
  }


  @override
  Widget build(BuildContext context) {
    globalContext = context;

    return AlertDialog(
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            Container(
              child: Text(
                'Opciones de foto',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.only(left: 8,right: 8,bottom: 15),
              alignment: Alignment.topCenter,
            ),
            GestureDetector(
              child: Container(
                child: Text('Tomar Una Foto',textAlign: TextAlign.center,),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 1,
                  )
                ),
              ),
              onTap: () => openCamera(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            GestureDetector(
              child: Container(
                child: Text('Seleccionar Foto',textAlign: TextAlign.center,),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1,
                    )
                ),
              ),
              onTap: () => selectPhoto(),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
            ),
             GestureDetector(
              child: canShowPhoto ?  Container(
                child: Text('Ver Foto Actual',textAlign: TextAlign.center,),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1,
                    )
                ),
              ) : SizedBox.shrink(),

              onTap: () async {
                try {
                  print('Se llama la busqueda de foto');
                  var dir = await getApplicationDocumentsDirectory();

                  final path = join(dir.path + '/myData' ,'$fileImageName.png',);

                  var fi = new FileImage(File(path)).evict().then((evicted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return showPhoto(context, Image.file(File(path)) );
                        });
                  });

                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
            ),

          ],
        ),
      ),
    );
  }


  Widget showPhoto(BuildContext context, Image image){

    return  AlertDialog(
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            image,

            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            RaisedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );

  }

}
