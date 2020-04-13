import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logik_groupv3/src/util/PrimitiveWrapper.dart';
import 'package:logik_groupv3/src/util/TakePictureScreen.dart';
import 'package:logik_groupv3/src/widgets/MyDocumentsListView.dart';
import 'package:logik_groupv3/src/widgets/MyTextFormField.dart';

import 'hotData/HotData.dart';
import 'models/Document.dart';
import 'models/Report.dart';

class DocumentsRoute extends StatefulWidget {
  Report currentReport;

  DocumentsRoute(this.currentReport);

  @override
  DocumentsRouteState createState() {
    return DocumentsRouteState(this.currentReport);
  }
}

class DocumentsRouteState extends State<DocumentsRoute> {

  Report currentReport;

  DocumentsRouteState(this.currentReport);

  @override
  void initState() {
    HotData.streamController.stream.listen((p) => {
          if (mounted) {setState(() {})}
        });
  }

  @override
  Widget build(BuildContext context) {
    //asigno el laboratorio con el que estoy trabajando
    HotData.currentLab = currentReport.nombreLaboratorio;

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Docs: ${currentReport.cliente}',
          minFontSize: 15,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear Nuevo Documento De Cliente',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MyDialog(currentReport,null);
                  });
            },
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 8.0),
          itemCount: currentReport.documentsForThisReport == null ? 0 : currentReport.documentsForThisReport.length,
          itemBuilder: (BuildContext context, int index) {
            return MyDocumentsListView(
              currentReport.documentsForThisReport[index],
              currentReport.documentsForThisReport,
              currentReport

            );
          }),
    );
  }
}

class MyDialog extends StatefulWidget {
  Report currentReport;
  Document documentForEdit;

  MyDialog(this.currentReport,this.documentForEdit);

  @override
  MyDialogState createState() => new MyDialogState(currentReport,documentForEdit);
}

class MyDialogState extends State<MyDialog> {
  bool emptyDocument = false;
  TextEditingController txtNewNoDocCliente = TextEditingController();
  Report currentReport;

  var _formKey = GlobalKey<FormState>();

  Document documentForEdit;

  MyDialogState(this.currentReport,this.documentForEdit);

  @override
  void initState() {
    if(documentForEdit != null)
      txtNewNoDocCliente.text = documentForEdit.numeroDocCliente;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                documentForEdit != null ? 'Editar No. Cliente' :'Nuevo No. Cliente',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: emptyDocument
                  ? null
                  : MyTextFormField(
                      emptyResponse: 'Ingresa No. De Documento',
                      hintText: 'Doc. Cliente',
                      textEditingController : txtNewNoDocCliente,
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Sin No. De Documento'),
                Checkbox(
                  value: emptyDocument,
                  onChanged: (bool value) {
                    if (mounted)
                      this.setState(() {
                        emptyDocument = value;
                      });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child:  Text(documentForEdit != null ? 'Guardar': "Crear"),

                    onPressed: () {
                      //print('Cantidad de docuemntos'+ currentReport.documentsForThisReport.first.numeroDocCliente);
                      if(documentForEdit != null){ //si es para editar
                        if(txtNewNoDocCliente.text.contains('NA-')){

                          Fluttertoast.showToast(
                              msg: "No puedes guardar como nombre 'NA-' ",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                          return;
                        }
                        print('Guardando documento editado..' + currentReport.numeroDeGuia);

                        //cambio el nombre de la imagen
                        TakePictureScreen.renamePhoto(documentForEdit.imagePathName, currentReport.nombreArchivoReporte+'-'+txtNewNoDocCliente.text);

                        documentForEdit.numeroDocCliente = txtNewNoDocCliente.text;
                        documentForEdit.imagePathName = currentReport.nombreArchivoReporte+'-'+txtNewNoDocCliente.text;



                        HotData.saveAll();
                        Navigator.pop(context);

                      }else{
                        print('no es para editar, es nuevo..');
                        if (currentReport.documentsForThisReport == null && (emptyDocument || _formKey.currentState.validate())){
                          currentReport.documentsForThisReport = List<Document>();
                          print('no habia ningun doc creado!');
                        }

                        if (emptyDocument) { //si es un No generico
                          Document lastNADocument = currentReport
                              .documentsForThisReport !=
                              null
                              ? currentReport.documentsForThisReport.lastWhere(
                                  (report) =>
                                  report.numeroDocCliente.contains('NA-'),
                              orElse: () => null)
                              : null;


                          Document newDoc;

                          if (lastNADocument == null) {
                            //significa que es el primer NA
                            newDoc = Document(numeroDocCliente: 'NA-0',fecha: DateFormat("dd/MM/yyyy").format(DateTime.now()));
                          } else {
                            //significa que ya habia un NA y debo obtener el ultimo

                            String nA =
                            lastNADocument.numeroDocCliente.split('-')[1];
                            int intNA = int.parse(nA);
                            intNA++;

                            newDoc = Document(
                              numeroDocCliente: 'NA-' + intNA.toString(),
                              fecha : DateFormat("dd/MM/yyyy").format(DateTime.now()),
                            );
                          }

                          newDoc.imagePathName = currentReport.nombreArchivoReporte+'-'+newDoc.numeroDocCliente;
                          currentReport.documentsForThisReport.add(newDoc);
                          HotData.saveAll();
                          Navigator.pop(context);

                        } else if (_formKey.currentState.validate()) {//si es un numero que puso el usuario
                          _formKey.currentState.save();

                          Document newDoc = Document(
                              numeroDocCliente: txtNewNoDocCliente.text,
                              fecha : DateFormat("dd/MM/yyyy").format(DateTime.now()));

                          newDoc.imagePathName = currentReport.nombreArchivoReporte+'-'+newDoc.numeroDocCliente;
                          currentReport.documentsForThisReport.add(newDoc);
                          HotData.saveAll();
                          Navigator.pop(context);
                        }
                      }

                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


}
