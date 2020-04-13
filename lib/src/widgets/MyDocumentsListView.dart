import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/RecordRoute.dart';
import 'package:logik_groupv3/src/models/Document.dart';
import 'package:logik_groupv3/src/models/Report.dart';
import 'package:logik_groupv3/src/util/TakePictureScreen.dart';

import '../DocumentsRoute.dart';
import 'Delete.dart';

class MyDocumentsListView extends StatelessWidget{
  Document currentDocument;
  List<Document> currentDocuments;
  Report currentReport;

  MyDocumentsListView(this.currentDocument,this.currentDocuments,this.currentReport);

  @override
  Widget build(BuildContext context) {
      currentDocument.numReferenciasRegistradas =
        currentDocument.recordsForThisDocClient != null ?
        currentDocument.recordsForThisDocClient.map((r) => r.codigo ).toList().toSet().length : 0;

      currentDocument.numProductosRegistrados = currentDocument.recordsForThisDocClient != null ?
      currentDocument.recordsForThisDocClient.map((r) => int.parse(r.cantidad)).toList().reduce((a,b) => a+b) : 0;

      return Padding(
        padding:
        new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: GestureDetector(
          child:

          Container(
            height: 80,
            color: Colors.white,

            //division entre el rojo y el contenido
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: 10,
                  color: currentDocument.hasImage ? Colors.green : Colors.red,
                ),
                Expanded(
                  //aqui esta la division entre el titulo y el contenido de abajo
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: AutoSizeText(
                            '${'Doc. Cliente. No. ' + currentDocument.numeroDocCliente}',
                            minFontSize: 15,
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        //aqui esta la diviosn entre el texto y los botones
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Expanded(
                                        child: AutoSizeText(
                                          currentDocument.numReferenciasRegistradas.toString() + ' Referencias Registradas',
                                          minFontSize: 10,
                                          //  maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          currentDocument.numProductosRegistrados.toString() + ' Productos Registrados',
                                          minFontSize: 10,
                                          //  maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${'Fecha ' + currentDocument.fecha}',
                                          minFontSize: 10,
                                          //  maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Container(
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    tooltip: 'Edita el Reporte',
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MyDialog( currentReport,currentDocument,);
                                          });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    tooltip: 'Toma la foto evidencia',
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {

                                            return TakePictureScreen.fromDocument(currentDocument);
                                          });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    tooltip: 'Elimina el reporte',
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Delete.fromDocument(currentDocuments,currentDocument);
                                          });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecordRoute(currentDocument)),
            );
          },

        )
    );
  }



}