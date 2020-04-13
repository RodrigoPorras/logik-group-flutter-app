import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/models/Report.dart';
import 'package:logik_groupv3/src/widgets/MyRecordsListView.dart';
import 'NewOrEditProductAuth.dart';
import 'hotData/HotData.dart';


class RecordAuthRoute extends StatefulWidget {
  Report currentReport;

  RecordAuthRoute(this.currentReport);

  @override
  RecordAuthRouteState createState() {
    return RecordAuthRouteState(this.currentReport);
  }
}

class RecordAuthRouteState extends State<RecordAuthRoute> {
  Report currentReport;

  RecordAuthRouteState(this.currentReport);

  @override
  void initState() {
    HotData.streamController.stream.listen((p) => {
      if (mounted) {setState(() {})}
    });
  }

  @override
  Widget build(BuildContext context) {
    //asigno el laboratorio con el que estoy trabajando en la autorizacion
    HotData.currentLab = currentReport.nombreLaboratorio;

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Productos de : ${currentReport.cliente}',
          minFontSize: 15,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear Nuevo Producto',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewOrEditProductAuth(currentReport: currentReport)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 8.0),
          itemCount: currentReport.recordsForThisAuth == null ? 0 : currentReport.recordsForThisAuth.length,
          itemBuilder: (BuildContext context, int index) {
            return MyRecordsListView(
              currentRecord : currentReport.recordsForThisAuth[index],
              currentRecords: currentReport.recordsForThisAuth,
            );
          }),
    );
  }
}