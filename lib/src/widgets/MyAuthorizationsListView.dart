import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/NewAuthorization.dart';
import 'package:logik_groupv3/src/models/Report.dart';
import 'package:logik_groupv3/src/util/TakePictureScreen.dart';

import '../DocumentsRoute.dart';
import '../NewReport.dart';
import '../RecordAuthRoute.dart';
import 'Delete.dart';

class MyAuthorizationsListView extends StatelessWidget{
  int index;
  List<Report> allReports = List<Report>();

  MyAuthorizationsListView({this.index,this.allReports});

  @override
  Widget build(BuildContext context) {
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
              children: <Widget>[
                Container(
                  width: 10,
                  color: allReports[index].hasImage ? Colors.green : Colors.red,
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
                            '${allReports[index].cliente}',
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
                                          allReports[index].recordsForThisAuth != null ?
                                          allReports[index].recordsForThisAuth.map((r) => int.parse(r.cantidad)).reduce((a,b) => a+b).toString() + ' Productos Registrados' :
                                          '0 Productos Registrados' ,
                                          minFontSize: 10,
                                          //  maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${allReports[index].nombreLaboratorio}',
                                          minFontSize: 10,
                                          //  maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${allReports[index].fechaRecepcionDevolucion}',
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
                                    tooltip: 'Edita La Autorizacion',
                                    onPressed: () {

                                      //cambiar a editar autorizacion
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => NewAuthorization(reportToEdit: allReports[index])),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    tooltip: 'Toma la foto evidencia',
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {

                                            return TakePictureScreen.fromReport(allReports[index]);
                                          });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    tooltip: 'Elimina La Autorizacion',
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Delete.fromAuthorization(allReports[index]);
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

            //aqui cambiar para ver los registros
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecordAuthRoute(allReports[index])),
            );

          },

        )
    );
  }

}