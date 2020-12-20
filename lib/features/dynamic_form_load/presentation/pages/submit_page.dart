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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Checks to be submitted: "),
            GridView.count(
              physics: ScrollPhysics(),
              childAspectRatio: 5,
              //adjust to change height
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: submittedChecks
                  .map((e) => SingleCheckModelSubmissionDisplay(check: e))
                  .toList(),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text("Submit to database"),
            )
          ],
        ),
      ),
    );
  }
}

class SingleCheckModelSubmissionDisplay extends StatelessWidget {
  final CheckModel check;

  const SingleCheckModelSubmissionDisplay({this.check});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: check.isSelected ? Colors.greenAccent : Colors.redAccent,
        child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            splashColor: Colors.blue,
            onTap: () => Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Shown!"))),
            child: ChecksDetailsColumn(check: check)));
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
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
        )
    );
  }
}
