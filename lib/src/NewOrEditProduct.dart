import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logik_groupv3/src/util/PrimitiveWrapper.dart';
import 'package:logik_groupv3/src/widgets/MyTextFormField.dart';

import 'hotData/HotData.dart';
import 'models/Document.dart';
import 'package:flutter/services.dart';

import 'models/Record.dart';

class NewOrEditProduct extends StatefulWidget {
  Document currentDocument;

  Record recordforEdit;

  NewOrEditProduct({this.currentDocument,this.recordforEdit});

  @override
  NewProductState createState() {
    return NewProductState(currentDocument,recordforEdit);
  }
}

class NewProductState extends State<NewOrEditProduct> {
  Document currentDocument;

  Record recordForEdit;

  final _formKey = GlobalKey<FormState>();

  NewProductState(this.currentDocument,this.recordForEdit);


  String motivoDevolucion = 'Motivo De Devolucion';

  DateTime selectedDate =   DateTime (DateTime.now().year,DateTime.now().month,30);

  var txtDateController = TextEditingController();
  var txtCodeControlller = TextEditingController();
  var txtDescription = TextEditingController();
  var txtCantidad = TextEditingController();
  var txtLote = TextEditingController();



  bool _selectDateValidated = true;

  String _dropdownError;

  @override
  void initState() {
    if(recordForEdit != null){
      txtCodeControlller.text = recordForEdit.codigo;
      txtDateController.text = recordForEdit.fechaDeVencimiento;
      txtDescription.text = recordForEdit.descripcionDelProducto;
      txtCantidad.text = recordForEdit.cantidad;
      txtLote.text = recordForEdit.lote;
      motivoDevolucion = recordForEdit.motivoDeDevolucion;

    }
    //txtCodeControlller.addListener(inputCodeOnChange); //esta ejecutandose cada que doy click cada qeu cambio letra cada todo,  mejor usare changued

  }

  @override
  Widget build(BuildContext context) {
    print('en new product tengo '+HotData.motivos.length.toString());
    print('El laboratorio actual es :' + HotData.currentLab);

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          recordForEdit != null ? 'Editar Producto' : 'Nuevo Producto',
          minFontSize: 15,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Guardar Producto Nuevo/Editado ',
            onPressed: () {

              _selectDateValidated = txtDateController.text.isEmpty ? false : true;
              setState(() {});

              _dropdownError = motivoDevolucion == 'Motivo De Devolucion' ? 'Seleccione un motivo De Devolucion' : null;

              if (_formKey.currentState.validate() && _selectDateValidated && motivoDevolucion != 'Motivo De Devolucion' ) {
                _formKey.currentState.save();


                if(recordForEdit != null){
                  //si es para editar
                  recordForEdit.codigo = txtCodeControlller.text;
                  recordForEdit.cantidad = txtCantidad.text;
                  recordForEdit.descripcionDelProducto = txtDescription.text;
                  recordForEdit.fechaDeVencimiento = txtDateController.text;
                  recordForEdit.lote = txtLote.text;
                  recordForEdit.motivoDeDevolucion = motivoDevolucion;
                }else{
                  //si es un producto nuevo
                  Record newRecord = Record(
                      codigo: txtCodeControlller.text,
                      cantidad: txtCantidad.text,
                      descripcionDelProducto: txtDescription.text,
                      fechaDeVencimiento: txtDateController.text,
                      lote: txtLote.text,
                      motivoDeDevolucion: motivoDevolucion
                  );

                  if (currentDocument.recordsForThisDocClient == null){
                    currentDocument.recordsForThisDocClient = List<Record>();
                    print('no habia ningun record creado!');
                  }
                  currentDocument.recordsForThisDocClient.add(newRecord);
                }

                HotData.saveAll();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      // Build a Form widget using the _formKey created above.
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10.0, top: 15.0),
                child: Row(children: <Widget>[
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                        child: TextFormField(
                          controller: txtCodeControlller,
                          decoration: InputDecoration(
                            hintText: 'Codigo (Si no existe poner NA)',
                          ),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Ingrese un codigo';
                            }
                            return null;
                          },
                          onChanged: (inp) => inputCodeOnChange(),
                        ),
                      )
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    tooltip: 'Edita el Reporte',
                    iconSize: 40.0,
                    onPressed: () {
                      barcodeScanning();
                    },
                  )
                ]),
              ),
              Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),

                  child: TextFormField(
                    controller: txtDescription,
                    decoration: InputDecoration(
                      hintText: 'Descripcion del producto',
                    ),
                    validator: (input) {
                      if (input.isEmpty || input == 'No Existe producto para este codigo') {
                        return 'Ingrese una descripcion';
                      }
                      return null;
                    },
                    onSaved: (input) => txtDescription.text = input,
                    onTap: () => txtDescription.text = txtDescription.text == 'No Existe producto para este codigo'? '' : txtDescription.text,
                    textCapitalization: TextCapitalization.characters,

                  ),
              ),
              MyTextFormField(
                  hintText: 'Cantidad',
                  emptyResponse: 'Ingrese una cantidad',
                  textEditingController: txtCantidad,
                textInputType: TextInputType.number,
              ),
              MyTextFormField(
                  hintText: 'Lote (Si no existe poner NA)',
                  emptyResponse: 'Ingrese un lote',
                  textEditingController: txtLote),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: TextField(
                  controller: txtDateController,
                  decoration: InputDecoration(
                    hintText: 'Fecha De Vencimiento',
                    errorText: _selectDateValidated ? null: 'Ingrese una fecha',
                  ),
                  onTap: () => _selectDate(context),
                  readOnly: true,

                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: DropdownButton<String>(
                  value: motivoDevolucion,
                  isExpanded: true,
                  hint: Text("Motivo De Devolucion", maxLines: 1),

                  items: HotData.motivos.map((String value) {
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
                      motivoDevolucion = value;
                      _dropdownError = null;
                    });
                  },
                ),

              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: _dropdownError == null
                    ? SizedBox.shrink()
                    : Text(_dropdownError ?? "",style: TextStyle(color: Colors.red),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;

        txtDateController.text = DateFormat("dd/MM/yyyy").format(selectedDate);
      });
  }

  bool isBarcode = false;

  Future barcodeScanning() async {
    String barcode;
    isBarcode = true;

    try {
      barcode = await BarcodeScanner.scan();
      setState( ()
      {
        txtCodeControlller.text = barcode;
      }
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.txtCodeControlller.text = 'No camera permission!';
        });
      } else {
        setState((){
          txtCodeControlller.text = 'Unknown error: $e';
        }
        );
      }
    } on FormatException {
      setState(() => txtCodeControlller.text = 'Nothing captured.');
    } catch (e) {
      setState(() => txtCodeControlller.text = 'Unknown error: $e');
    }

    if(barcode == null)
      return;

    try{
      print( 'LPT'+barcode.substring(7,barcode.length-1));

      switch(HotData.currentLab){
        case 'LEGRAND':

          txtDescription.text = HotData.legrandDB['LPT' +barcode.substring(7,barcode.length-1)]+ "";
          break;
        case 'PERCOS':
          txtDescription.text = HotData.percosDB[barcode.substring(7,barcode.length-1)]+ "";
          break;
        case 'LASANTE':
          txtDescription.text = HotData.lasanteDB[barcode];
          break;
      }
    }catch(exception){
      txtDescription.text = 'No Existe producto para este codigo';
    }

    isBarcode = false;
  }


  void inputCodeOnChange(){
    if(isBarcode) return;

    String text = txtCodeControlller.text;
    //bool hasFocus = txtCodeControlller.hasFocus;
    //do your text transforming


      try{
        print( 'LPT'+text+ " lab: "+ HotData.currentLab);

          switch(HotData.currentLab){
            case 'LEGRAND':

              txtDescription.text = HotData.legrandDB['LPT'+text]+"";

              break;
            case 'PERCOS':
              txtDescription.text = HotData.percosDB[text] + "";
              break;
            case 'LASANTE':
              txtDescription.text = HotData.lasanteDB[text]+ "";
              break;
          }
      }catch(exception){
            txtDescription.text = 'No Existe producto para este codigo';
          }


  }


}
