import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logik_groupv3/src/util/JSONManager.dart';
import 'package:logik_groupv3/src/util/TakePictureScreen.dart';
import 'package:logik_groupv3/src/widgets/MySaveButton.dart';
import 'package:logik_groupv3/src/widgets/MyTextFormField.dart';
import 'package:logik_groupv3/src/widgets/MyTextFormFieldSearch.dart';
import 'package:path_provider/path_provider.dart';

import 'hotData/HotData.dart';
import 'models/Report.dart';
import 'models/Reports.dart';

class NewAuthorization extends StatefulWidget {
  Report reportToEdit;

  NewAuthorization({this.reportToEdit});

  @override
  NewAuthorizationState createState() {
    return NewAuthorizationState(reportToEdit);
  }
}

class NewAuthorizationState extends State<NewAuthorization> {
  final _formKey = GlobalKey<FormState>();

  //los strings del form (usando wrappers)
  TextEditingController cliente = TextEditingController();
  TextEditingController ciudad = TextEditingController();
  TextEditingController numeroDeGuia = TextEditingController();
  TextEditingController nombreArchivoReporte = TextEditingController();
  String nombreLaboratorio = 'Laboratorio';

  Report reportToEdit;

  String _dropdownError;

  NewAuthorizationState(this.reportToEdit);

  //se usará para editar los reportes
  @override
  void initState() {
    super.initState();

    if (reportToEdit != null) {
      cliente.text = reportToEdit.cliente;
      nombreLaboratorio = reportToEdit.nombreLaboratorio;
      ciudad.text = reportToEdit.ciudad;
      numeroDeGuia.text = reportToEdit.numeroDeGuia;
    } //si es nulo significa que es uno nuevo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(reportToEdit != null
              ? 'Editar Autorizacion'
              : 'Nueva Autorizacion')),

      // Build a Form widget using the _formKey created above.
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.88,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MyTextFormFieldSearch(
                    hintText: 'Nombre Cliente',
                    emptyResponse: 'Ingrese un cliente',
                    listSuggestion: HotData.clients,
                    typeAheadController: cliente),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: DropdownButton<String>(
                    value: nombreLaboratorio,
                    isExpanded: true,
                    hint: Text("Motivo De Devolucion", maxLines: 1),
                    items: <String>[
                      'Laboratorio',
                      'LEGRAND',
                      'PERCOS',
                      'LASANTE'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value ?? "",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        nombreLaboratorio = value;
                        _dropdownError = null;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: _dropdownError == null
                      ? SizedBox.shrink()
                      : Text(
                          _dropdownError ?? "",
                          style: TextStyle(color: Colors.red),
                        ),
                ),
                MyTextFormField(
                    hintText: 'Ciudad',
                    emptyResponse: 'Ingrese una ciudad',
                    textEditingController: ciudad),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: TextFormField(
                    controller: numeroDeGuia,
                    decoration: InputDecoration(
                      hintText: 'Numero De Guia',
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                  child: Text(
                      'Fecha: ' +
                          (reportToEdit != null
                              ? reportToEdit.fechaRecepcionDevolucion
                              : DateFormat("dd/MM/yyyy")
                                  .format(DateTime.now())),
                      style: TextStyle(fontSize: 20.0)),
                ),
                Expanded(
                    child: MySaveButton(
                  onTap: () {
                    setState(() {
                      _dropdownError = nombreLaboratorio == 'Laboratorio'
                          ? 'Seleccione un laboratorio'
                          : _dropdownError = null;
                    });

                    if (nombreLaboratorio == 'Laboratorio') return;

                    if (reportToEdit != null) {
                      //editando una autorizacion

                      reportToEdit.cliente = cliente.text;
                      reportToEdit.nombreLaboratorio = nombreLaboratorio;
                      reportToEdit.ciudad = ciudad.text;
                      reportToEdit.numeroDeGuia = numeroDeGuia.text;

                      String imageFileName = reportToEdit.cliente +
                          '-' +
                          reportToEdit.nombreLaboratorio +
                          '-' +
                          reportToEdit.ciudad +
                          '-' +
                          reportToEdit.numeroDeGuia;

                      TakePictureScreen.renamePhoto(
                          reportToEdit.nombreArchivoReporte, imageFileName);
                      reportToEdit.nombreArchivoReporte = imageFileName;

                      HotData.saveAll();
                    } else {
                      //creo la nueva autorizacion
                      String imageFileName = cliente.text +
                          '-' +
                          nombreLaboratorio +
                          '-' +
                          ciudad.text +
                          '-' +
                          numeroDeGuia.text;

                      Report report = Report(
                        cliente: cliente.text,
                        ciudad: ciudad.text,
                        numeroDeGuia: numeroDeGuia.text,
                        fechaRecepcionDevolucion:
                            DateFormat("dd/MM/yyyy").format(DateTime.now()),
                        nombreArchivoReporte: imageFileName,
                        nombreLaboratorio: nombreLaboratorio,
                        tipo: 'autorizacion',
                      );

                      Reports allReports;

                      if (HotData.reportsContent == null) {
                        List<Report> listReports = [report];
                        allReports = Reports(allReports: listReports);
                        JSONManager.createJSON(allReports);
                      } else {
                        JSONManager.addReportToJSON(report);
                        //allReport = Reports.fromJson(fileContent);
                        //allReport.allReports.add(report);
                      }

                      HotData.LoadReportsInfo();
                    }

                    Navigator.pop(context);

                    //print(json.encode(report));
                  },
                  formKey: _formKey,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
