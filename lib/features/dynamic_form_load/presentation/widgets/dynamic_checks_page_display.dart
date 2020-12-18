import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_type.dart';
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
    if (
    (checksPageModel.storedSegments.length > 0) &&
        (checksPageModel.storedChecks.length > 0) ){
      List<ListItem> segments = buildList(checksPageModel);
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: ListView.builder(
            itemCount: segments.length,
            itemBuilder: (context, index) {
              final item = segments[index];
              return ListTile(title: item.buildSegment(context));
            }),
      );
    }
    return Container();
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
  List<CheckModel> checks = List();

  Segment({@required this.title, @required this.checks});

  @override
  Widget buildSegment(BuildContext context) {
    double sizedBoxHeight = 0;
    if (checks.length == 1) {
      sizedBoxHeight = ( ((MediaQuery.of(context).size.height) / 5) * (checks.length) );
    } else {
      sizedBoxHeight = ( ((MediaQuery.of(context).size.height) / 5) * (checks.length - 1) );
    }
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              Row(
                children: [
                  Text(this.title, style: TextStyle(fontSize: 25),)
                ],
              ),
              SizedBox(
                height: sizedBoxHeight,
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

// ignore: must_be_immutable
class CheckModelDisplay extends StatefulWidget {
  List<CheckModel> checks = List();

  CheckModelDisplay({@required this.checks});

  @override
  _CheckModelDisplayState createState() => new _CheckModelDisplayState(checks: this.checks);

}

class _CheckModelDisplayState extends State<CheckModelDisplay> {
  List<CheckModel> checks = List();

  _CheckModelDisplayState({@required this.checks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this.checks.length,
        itemBuilder: (contents, index) {
          final item = checks[index];
          return SizedBox(height: 90,child: ListTile(title: buildCheckItemWidget(item)));
        });
  }

  Widget buildCheckItemWidget(CheckModel item) {
    Widget avatar;
    if (item.imageLink != null && Uri.parse(item.imageLink).isAbsolute) {
      avatar = CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(item.imageLink),
        backgroundColor: Colors.white,
      );
    }
    if (item.type == CheckType.YES_NO) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.text, style: TextStyle(fontSize: 20),),
              Text(item.subText, style: TextStyle(fontSize: 15),),
              avatar == null ? Container() : avatar
            ],
          ),
          Spacer(),
          Checkbox(
              value: item.isSelected ?? false,
              onChanged: (bool value) {
                setState(() {
                  item.isSelected = value;
                });
              })
        ],
      );
    } else {
     return Container();
    }
  }
}
