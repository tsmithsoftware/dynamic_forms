import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/segment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicChecksPageDisplay extends StatelessWidget {
  final ChecksPageModel checksPageModel;

  const DynamicChecksPageDisplay({Key key, this.checksPageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ListItem> segments = buildList(checksPageModel);
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
          itemCount: segments.length,
          itemBuilder: (context, index) {
            final item = segments[index];
            return ListTile(title: item.buildSegment(context));
          }),
    );
  }

  List<ListItem> buildList(ChecksPageModel checksPageModel) {
    List<Segment> listedSegments = [];
    for (SegmentModel segment in checksPageModel.storedSegments) {
      listedSegments
          .add(Segment(title: segment.title, checks: segment.checksList));
    }
    return listedSegments;
  }
}

abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildSegment(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class Segment implements ListItem {
  String title;
  List<CheckModel> checks;

  Segment({@required this.title, @required this.checks});

  @override
  Widget buildSegment(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              Row(
                children: [
                  Text(this.title)
                ],
              ),
              SizedBox(
                height: ( (MediaQuery.of(context).size.height) / 3) / 3,
                  width: MediaQuery.of(context).size.width,
                child: CheckModelDisplay(checks: this.checks),
              )
            ],
          ),
        )
      ],
    );
  }
}

class CheckModelDisplay extends StatelessWidget {
  List<CheckModel> checks;

  CheckModelDisplay({@required this.checks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this.checks.length,
        itemBuilder: (contents, index) {
          final item = checks[index];
          return SizedBox(height: 50,child: ListTile(title: buildCheckItemWidget(item)));
        });
  }

  Widget buildCheckItemWidget(CheckModel item) {
    return Row(
      children: [
        Column(
          children: [
            Text(item.text),
            Text(item.subText)
          ],
        ),
        Checkbox(onChanged: (bool value) {  }, value: true,)
      ],
    );
  }
}
