import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/util/PrimitiveWrapper.dart';


class MyTextFormField extends StatelessWidget{
  String hintText;
  String emptyResponse;
  PrimitiveWrapper ouputValue;
  TextInputType textInputType;
  TextEditingController textEditingController;

  MyTextFormField({this.hintText, this.emptyResponse, this.ouputValue,this.textInputType,this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: TextFormField(
        controller: textEditingController != null ? textEditingController : null,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: (input) {
          if (input.isEmpty) {
            return emptyResponse;
          }
          return null;
        },
        onSaved: (input) {
          if(ouputValue != null)
            ouputValue.value = input;
        },
        textCapitalization: TextCapitalization.characters,
        keyboardType: textInputType != null ? textInputType : TextInputType.text,
      ),
    );
  }

  //keyboardType: TextInputType.number,

}
