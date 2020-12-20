import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/pages/submit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitControls extends StatefulWidget {
  final ChecksPageModel checksPage;

  SubmitControls({this.checksPage});

  @override
  State<StatefulWidget> createState() =>
      SubmitControlsState(checksPage: checksPage);
}

class SubmitControlsState extends State<SubmitControls> {
  ChecksPageModel checksPage;

  SubmitControlsState({this.checksPage});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("Submit"),
        onPressed: () =>
            Get.to(SubmitPage(submittedChecks: checksPage.storedChecks)));
  }
}
