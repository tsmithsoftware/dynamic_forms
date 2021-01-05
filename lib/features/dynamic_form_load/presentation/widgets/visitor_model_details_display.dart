import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VisitorModelDetailsDisplay extends StatefulWidget {
  VisitorDisplayModel visitorModel;

  VisitorModelDetailsDisplay({this.visitorModel});

  @override
  State<StatefulWidget> createState() => _VisitorModelDetailsDisplayState(visitorModel: this.visitorModel);

}

class _VisitorModelDetailsDisplayState extends State<VisitorModelDetailsDisplay> {
  VisitorDisplayModel visitorModel;

  _VisitorModelDetailsDisplayState({this.visitorModel});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Visitor Name:"),
      TextField(
        onChanged: (newName) { visitorModel.visitorName = newName; },
      ),
      SizedBox(height: 10,),
      Text("Visitor Company:"),
      TextField(
        onChanged: (newCompany) { visitorModel.visitorCompany = newCompany; },
      ),
      SizedBox(height: 10,)
    ]);
  }

}

class VisitorDisplayModel {
  String visitorName;
  String visitorCompany;
}