import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/NewOrEditProduct.dart';
import 'package:logik_groupv3/src/widgets/MyRecordsListView.dart';
import 'hotData/HotData.dart';
import 'models/Document.dart';



class RecordRoute extends StatefulWidget {
  Document currentDocument;

  RecordRoute(this.currentDocument);

  @override
  RecordRouteState createState() {
    return RecordRouteState(this.currentDocument);
  }
}

class RecordRouteState extends State<RecordRoute> {
  Document currentDocument;

  RecordRouteState(this.currentDocument);

  @override
  void initState() {
    HotData.streamController.stream.listen((p) => {
      if (mounted) {setState(() {})}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          'Productos de : ${currentDocument.numeroDocCliente}',
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
                MaterialPageRoute(builder: (context) => NewOrEditProduct(currentDocument: currentDocument)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 8.0),
          itemCount: currentDocument.recordsForThisDocClient == null ? 0 : currentDocument.recordsForThisDocClient.length,
          itemBuilder: (BuildContext context, int index) {
            return MyRecordsListView(
              currentRecord : currentDocument.recordsForThisDocClient[index],
              currentRecords: currentDocument.recordsForThisDocClient,
            );
          }),
    );
  }
}