import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/check_submission_model_list.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visitor_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/dynamic_forms_bloc/bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/form_submit_bloc/form_submit_bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/form_submit_bloc/form_submit_event.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/pages/dynamic_checks_page.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/loading_indicator.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/visitor_model_details_display.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../base_injection_container.dart';

class SubmitPage extends StatelessWidget {
  final List<CheckModel> submittedChecks;
  final VisitorDisplayModel visitorModel;

  const SubmitPage({this.submittedChecks, this.visitorModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Checks Submission'),
        ),
        body: SafeArea(child: buildBody(context)));
  }

  BlocProvider<FormSubmitBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FormSubmitBloc>(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder(
              cubit: sl<FormSubmitBloc>(),
              builder: (context, state) {
                if (state is Loading) {
                  return LoadingIndicator();
                } else if (state is Error) {
                  return MessageDisplay(
                    message: state.message,
                  );
                } else if (state is Loaded) {
                  return MessageDisplay(message: "Checks submitted to DB!");
                }
                return Column(
                  children: [
                    Text("Checks to be submitted: "),
                    GridView.count(
                      physics: ScrollPhysics(),
                      childAspectRatio: 5,
                      //adjust to change height
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      crossAxisSpacing: 32,
                      mainAxisSpacing: 32,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: submittedChecks
                          .map((e) =>
                              SingleCheckModelSubmissionDisplay(check: e))
                          .toList(),
                    ),
                    RaisedButton(
                      onPressed: () {
                        List<CheckSubmissionModel> checkList = [];
                        submittedChecks.forEach((element) {
                          checkList.add(CheckSubmissionModel(
                              checkId: element.checkId,
                              checkStatus: element.isSelected));
                        });

                        BlocProvider.of<FormSubmitBloc>(context).add(
                            SubmitVisitorSigninEvent(VisitModel(
                                siteId: 1,
                                visitor: VisitorModel(visitorName: visitorModel.visitorName, visitorCompany: visitorModel.visitorCompany),
                                checks: CheckSubmissionModelList(
                                    list: checkList))));

                        showDialog(
                            context: context,
                            child: Column(
                              children: [
                                Text("Submitted!"),
                                RaisedButton(
                                  onPressed: () {
                                    Get.to(DynamicChecksPage());
                                  },
                                  child: Text("Return to main page"),
                                )
                              ],
                            ));
                      },
                      child: Text("Submit to database"),
                    )
                  ],
                );
              }),
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
    Color cardColour = Colors.redAccent;
    if (check.submissionText.isEmpty) {
      cardColour = check.isSelected ? Colors.greenAccent : Colors.redAccent;
    } else {
      cardColour = Colors.greenAccent;
    }

    return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        color: cardColour,
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
    Widget container = Container();
    if (check.submissionText.isNotEmpty) {
      container = Text(check.submissionText);
    }

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
            ),
            container
          ],
        ));
  }
}
