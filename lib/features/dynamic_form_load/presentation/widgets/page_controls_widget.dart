import 'package:dynamic_forms/features/dynamic_form_load/presentation/bloc/dynamic_forms_bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageControls extends StatefulWidget {
  const PageControls({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageControlsState();
}

class _PageControlsState extends State<PageControls> {

  static const UK_CHECKS_ID = "1";
  static const AU_CHECKS_ID = "2";
  static const NZ_CHECKS_ID = "3";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RaisedButton(child: Text("UK Checks"),onPressed: () => dispatchConcrete(UK_CHECKS_ID)),
        SizedBox(width: 10),
        RaisedButton(child: Text("AU Checks"),onPressed: () => dispatchConcrete(AU_CHECKS_ID)),
        SizedBox(width: 10),
        RaisedButton(child: Text("NZ Checks"),onPressed: () => dispatchConcrete(NZ_CHECKS_ID)),
        SizedBox(width: 10),
      ],
    );
  }

  void dispatchConcrete(String countryId) {
    BlocProvider.of<DynamicChecksLoadBloc>(context)
        .add(GetChecksPageEvent(countryId));
  }
}