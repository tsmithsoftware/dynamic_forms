import 'dart:convert';
import 'dart:io';

import 'package:dynamic_forms/common/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/sign_in_visitor_response_model.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/visit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class ChecksPageRemoteDataSource {
  Future<ChecksPageModel> getChecksPage(int countryNumber);

  Future<SignInVisitorResponseModel> signInVisitor(VisitModel visit);
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
    }).timeout(Duration(seconds: 5), onTimeout: () {
      throw ServerException();
    },);

    if (response.statusCode == 200) {
      return ChecksPageModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SignInVisitorResponseModel> signInVisitor(VisitModel visit) async {
    final response = await client.post('http://10.0.2.2:4000/visits', headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.toString()
    }).timeout(Duration(seconds: 5), onTimeout: () {
      throw ServerException();
    });

    if (response.statusCode == 200) {
      return SignInVisitorResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
