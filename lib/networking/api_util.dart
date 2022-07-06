import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';
import 'api_exception.dart';

Future<dynamic> callPost(String url, Map data,
    {@required Function? onResponse,
    Function? onError,
    String token = "",
    bool showLoader = true,
    bool hideLoader = true}) async {
  if (showLoader) Utils.showLoader();
  try {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json'
    };
    headers.addIf(token.isNotEmpty, "Authorization", "Token " + token);

    Utils.print('headers: ' + json.encode(headers));

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );

    return _returnResponse(response, onResponse, onError, hideLoader);
  } on SocketException catch (_) {
    Utils.print(_.toString());

    onError!();

    Utils.showSnackbar('No Internet Connection');
    Utils.hideLoader();
    return;
  } catch (e) {
    onError!();

    Utils.showSnackbar('Something went wrong');
    Utils.hideLoader();
  }
}

Future<dynamic> callGet(String url,
    {@required Function? onResponse,
    Function? onError,
    String token = "",
    bool showLoader = true,
    bool hideLoader = true}) async {
  if (showLoader) Utils.showLoader();
  try {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json'
    };
    headers.addIf(token.isNotEmpty, "Authorization", "Token " + token);

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    return _returnResponse(response, onResponse, onError, hideLoader);
  } on SocketException catch (_) {
    Utils.print(_.toString());

    onError!();

    Utils.showSnackbar('No Internet Connection');
    Utils.hideLoader();
    return;
  } catch (e) {
    onError!();

    Utils.showSnackbar('Something went wrong');
    Utils.hideLoader();
  }
}

_returnResponse(http.Response response, Function? onResponse, Function? onError,
    bool hideLoader) async {
  Map responseJson = {};
  try {
    responseJson = jsonDecode(response.body);
  } catch (exception) {
    responseJson['message'] = "Something went wrong";
    if (hideLoader) Utils.hideLoader();

    Utils.print(exception.toString());
  }
  switch (response.statusCode) {
    case 200:
      if (hideLoader) Utils.hideLoader();

      onResponse!(response);

      return;

    case 400:
      if (onError != null) {
        onError();
      }
      Utils.hideLoader();

      throw BadRequestException(response.body.toString());
    case 404:
      onError!();

      Utils.hideLoader();

      throw InvalidInputException(response.body.toString());
    case 401:
    case 403:
      onError!();

      Utils.hideLoader();

      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      onError!();

      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
