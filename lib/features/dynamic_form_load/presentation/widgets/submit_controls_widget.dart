import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/pages/submit_page.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/visitor_model_details_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitControls extends StatefulWidget {
  final ChecksPageModel checksPage;
  final VisitorDisplayModel visitorModel;

  SubmitControls({this.checksPage, this.visitorModel});

  @override
  State<StatefulWidget> createState() =>
      SubmitControlsState(checksPage: checksPage, visitorModel: visitorModel);
}

class SubmitControlsState extends State<SubmitControls> {
  ChecksPageModel checksPage;
  final VisitorDisplayModel visitorModel;

  SubmitControlsState({this.checksPage, this.visitorModel});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("Submit"),
        onPressed: () =>
            Get.to(SubmitPage(submittedChecks: checksPage.storedChecks, visitorModel: visitorModel)));
  }
}
