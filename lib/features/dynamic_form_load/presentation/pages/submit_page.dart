import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitPage extends StatelessWidget {
  final List<CheckModel> submittedChecks;

  const SubmitPage({this.submittedChecks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Checks Submission'),
        ),
        body: SafeArea(child: buildBody(context)));
  }

  buildBody(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: submittedChecks.length,
              itemBuilder: (BuildContext ctxt, int index) {
                CheckModel model = submittedChecks[index];
                return SingleCheckModelSubmissionDisplay(check: model);
              })),
    );
  }
}

class SingleCheckModelSubmissionDisplay extends StatelessWidget {
  final CheckModel check;

  const SingleCheckModelSubmissionDisplay({this.check});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: check.isSelected
            ? buildSelectedCheck(context)
            : buildUnselectedCheck(context));
  }

  Widget buildUnselectedCheck(BuildContext context) {
    return Container(
      width: 5,
      color: Colors.redAccent,
      child: ChecksDetailsColumn(check: check),
    );
  }

  Widget buildSelectedCheck(BuildContext context) {
    return Container(
      width: 50,
      color: Colors.greenAccent,
      child: ChecksDetailsColumn(check: check),
    );
  }
}

class ChecksDetailsColumn extends StatelessWidget {
  const ChecksDetailsColumn({
    Key key,
    @required this.check,
  }) : super(key: key);

  final CheckModel check;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          check.text,
          softWrap: true,
        ),
        Text(
          check.subText,
          softWrap: true,
        )
      ],
    );
  }
}
