import 'dart:convert';
import 'dart:io';

import 'package:dynamic_forms/core/error/exception.dart';
import 'package:dynamic_forms/features/dynamic_form_load/data/models/checks_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class ChecksPageRemoteDataSource {
  Future<ChecksPageModel> getChecksPage(int countryNumber);
}

class ChecksPageRemoteDataSourceImpl implements ChecksPageRemoteDataSource {
  final http.Client client;

  ChecksPageRemoteDataSourceImpl({@required this.client});
  @override
  Future<ChecksPageModel> getChecksPage(int countryNumber) async {
    final response = await client.get(
        'http://192.168.0.5:8080/checks/$countryNumber',
      headers: { HttpHeaders.contentTypeHeader: ContentType.json.toString() }
    );

    if (response.statusCode == 200) {
      return ChecksPageModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

}