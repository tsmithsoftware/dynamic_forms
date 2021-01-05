import 'package:dynamic_forms/base_injection_container.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/dynamic_forms_bloc/bloc.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/submit_controls_widget.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/visitor_model_details_display.dart';
import 'package:dynamic_forms/features/dynamic_form_load/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class DynamicChecksPage extends StatelessWidget {
  VisitorDisplayModel _visitorModel = VisitorDisplayModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Checks'),
      ),
        body:
            SafeArea(child: SingleChildScrollView(child: buildBody(context))));
  }

  BlocProvider<DynamicChecksLoadBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DynamicChecksLoadBloc>(),
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                // Top half
              BlocBuilder<DynamicChecksLoadBloc, DynamicChecksLoadState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: "start searching!",
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return SingleChildScrollView(child: Column(
                      children: [
                        DynamicChecksPageDisplay(
                            checksPageModel: state.checksPage),
                        SubmitControls(checksPage: state.checksPage, visitorModel: _visitorModel)
                      ],
                    ));
                  }
                  else if (state is Error) {
                    return MessageDisplay (
                      message: state.message,
                    );
                  }
                  return Container();
                },
              ),
                // Bottom half
                VisitorModelDetailsDisplay(visitorModel: _visitorModel),
                PageControls()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
