import 'package:flutter/material.dart';

class MySaveButton extends StatelessWidget{
  var onTap;
  var formKey;


  MySaveButton({this.onTap,this.formKey});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return new Align(
          alignment: Alignment.bottomCenter,
          child: Builder(builder: (BuildContext aContext) {
            return GestureDetector(
                onTap: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (formKey.currentState.validate()) {

                    formKey.currentState.save();//guardo todas las variables

                    // If the form is valid, display a Snackbar.
                    onTap();
                    Scaffold.of(aContext).showSnackBar(
                        SnackBar(content: Text('Procesando...')));
                    //Navigator.pop(context);
                  }
                },
                child: new Container(
                  width: width,
                  height: height * 0.1,
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: new Text("Guardar",
                      style:
                      TextStyle(color: Colors.white, fontSize: 25.0)),
                )

            );
          }),
        );

  }


}
