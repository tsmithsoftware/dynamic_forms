import 'dart:convert';
import 'dart:io';

import 'package:dynamic_forms/core/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class ChecksPageRemoteDataSource {
  Future<ChecksPageModel> getChecksPage(int countryNumber);

  Future<bool> signInVisitor(VisitModel visit);
}

class ChecksPageRemoteDataSourceImpl implements ChecksPageRemoteDataSource {
  final http.Client client;

  ChecksPageRemoteDataSourceImpl({@required this.client});
  @override
  Future<ChecksPageModel> getChecksPage(int countryNumber) async {
    // use 10.0.2.2. as local emulator address
    final response = await client
        .get('http://10.0.2.2:4000/checks?countryId=$countryNumber', headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.toString()
    }).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return ChecksPageModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> signInVisitor(VisitModel visit) {
    // TODO: implement signInVisitor
    throw UnimplementedError();
  }
}
