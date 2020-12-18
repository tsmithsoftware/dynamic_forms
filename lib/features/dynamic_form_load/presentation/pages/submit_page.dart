import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitPage extends StatelessWidget {
  final List<CheckModel> submittedChecks;

  const SubmitPage({this.submittedChecks});

  @override
  Widget build(BuildContext context) {
    String submit = "Submitted! No Data!";
    if (submittedChecks.length > 0) {
      submit = "Submitted! Data length: ${submittedChecks.length}";
    }
    return Column(
      children: [
        Text(submit)
      ],
    );
  }

}