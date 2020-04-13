import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/models/Record.dart';

import '../NewOrEditProduct.dart';
import 'Delete.dart';

class MyRecordsListView extends StatelessWidget{
  Record currentRecord;
  List<Record> currentRecords;

  MyRecordsListView({this.currentRecord, this.currentRecords});

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
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

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
                            '${ currentRecord.descripcionDelProducto}',
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
                                          'Lote: '+currentRecord.lote + '   Mot. Dev: '+currentRecord.motivoDeDevolucion,
                                          minFontSize: 10,
                                          //  maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${currentRecord.cantidad+' Registrados   Cod:'+currentRecord.codigo }',
                                          minFontSize: 10,
                                          //  maxLines: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${'Fecha Vencimiento: ' + currentRecord.fechaDeVencimiento}',
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
                                    tooltip: 'Edita el producto',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => NewOrEditProduct(recordforEdit: currentRecord,)),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    tooltip: 'Elimina el producto',
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Delete.fromRecord(currentRecords,currentRecord);
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

          },

        )
    );
  }



}