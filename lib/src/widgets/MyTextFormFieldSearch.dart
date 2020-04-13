import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/util/PrimitiveWrapper.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MyTextFormFieldSearch extends StatelessWidget {
  String hintText;
  String emptyResponse;
  List<String> listSuggestion;
  PrimitiveWrapper outputValue;

  TextEditingController typeAheadController;


  MyTextFormFieldSearch({this.hintText, this.emptyResponse, this.listSuggestion, this.outputValue,this.typeAheadController });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: TypeAheadFormField(
        getImmediateSuggestions: true,

        textFieldConfiguration: TextFieldConfiguration(
            controller: this.typeAheadController,
            decoration: InputDecoration(labelText: hintText)),
        suggestionsCallback: (pattern) {
          return pattern.isEmpty
              ? listSuggestion
              : listSuggestion
              .where((letter) => letter
              .toLowerCase()
              .contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          this.typeAheadController.text = suggestion.toString().substring(0,suggestion.toString().length-1) ;//hay un problema qeu guarda un new line pero no lo detecta
        },
        validator: (input) {
          if (input.isEmpty) {
            return emptyResponse;
          }
          return null;
        },
        onSaved: (input) {
          if(outputValue != null)
            outputValue.value = input;
        }
      ),
    );
  }



}
