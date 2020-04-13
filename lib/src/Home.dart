import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logik_groupv3/src/NewAuthorization.dart';
import 'package:logik_groupv3/src/NewReport.dart';
import 'package:logik_groupv3/src/UploadingRoute.dart';
import 'package:logik_groupv3/src/util/JSONManager.dart';
import 'package:logik_groupv3/src/util/MyFirebase.dart';
import 'package:logik_groupv3/src/widgets/MyAuthorizationsListView.dart';
import 'package:logik_groupv3/src/widgets/MyReportsListView.dart';
import 'hotData/HotData.dart';

import 'package:firebase_auth/firebase_auth.dart';



class HomeState extends State<Home> {
  String title = 'Reportes';

  @override
  void initState() {
    HotData.streamController.stream.listen(
        (p) => setState(() {

        })
    );
    HotData.LoadReportsInfo();
    HotData.loadMotivos(context);
    HotData.loadAllLaboratoriesDB(context);
    HotData.getClientsFormTxt(context);

  }

  //no se puede imprimir el nombre del usuario porque es anonimo
  Future<FirebaseUser> signInAnon() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = (await _auth.signInAnonymously()).user;
    return user;
  }

  int returnItemCountForReports(){
    if (HotData.allReports != null){
      if(title == 'Reportes'){
        print('Cantidad actual de reportes: ' + HotData.allReports.length.toString());
        return HotData.allReports.where((r) => r.tipo == 'reporte').length;
      }else if(title == 'Autorizaciones'){
        return HotData.allReports.where((r) => r.tipo == 'autorizacion').length;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    print('Se llama el build del Home');
    HotData.getId(context);//no dejo en el init

    var size = MediaQuery.of(context).size;
    var width = size.width;

    //print(reportsContent);

    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              tooltip: 'Enviar Todo',
              onPressed: () {

                if(HotData.fileExists && HotData.allReports.length > 0){
                  signInAnon().then((FirebaseUser user){

                    printToast('Login Exitoso', Colors.green);

                    showDialog(

                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return UploadingRoute();
                        });

                  }).catchError((e){

                    printToast('Error En Login: $e', Colors.red);

                  });
                }else{
                  printToast('No hay archivos para enviar', Colors.red);
                }

              },
            ),
          ],

      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 8.0),

          itemCount: returnItemCountForReports(),

          itemBuilder: (BuildContext context, int index) {
            if(title == 'Reportes'){
              return MyReportsListView(index: index,allReports:  HotData.allReports != null ?   HotData.allReports.where((r) => r.tipo == 'reporte').toList() : null,);
            }
            else
              return MyAuthorizationsListView(index: index,allReports:  HotData.allReports  != null? HotData.allReports.where((r) => r.tipo == 'autorizacion').toList() : null,);
          }),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,

          children: <Widget>[
            DrawerHeader(
              child: ListView(children: <Widget>[
                NavigationDrawerIcon(),
                Center(
                  child: Text(
                    'LOGISTICA INVERSA',
                    style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                  ),
                ),
              ]),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.zero,
            ),
            ListTile(
              title: Text('Reportes'),
              onTap: () {
                // Update the state of the app
                // ...
                title = 'Reportes';
                setState(() {});
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Autorizaciones'),
              onTap: () {
                // Update the state of the app
                // ...
                title = 'Autorizaciones';
                setState(() {});
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            title == 'Reportes' ?
              MaterialPageRoute(builder: (context) => NewReport(reportToEdit: null))
              : MaterialPageRoute(builder: (context) => NewAuthorization(reportToEdit: null)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void printToast(String message, Color color){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();

}

class NavigationDrawerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    AssetImage assetImage = AssetImage('assets/images/logoLogikGroup.png');
    Image logikGroupIcon = Image(
      image: assetImage,
      width: size.width * 0.20,
      height: size.height * 0.20,
    );
    return Container(child: logikGroupIcon);
  }
}
