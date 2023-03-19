import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/poll.dart';
import '../models/response_body.dart';
import '../models/resulpoll.dart';

enum HttpMethod {
  get,
  post,
}

extension ParseToString on HttpMethod {
  String toShortStringUpperCase() {
    return toString().split('.').last.toUpperCase();
  }
}

class ApiClient {
  // todo: กำหนด base URL ให้เหมาะสม !!!
  static const apiBaseUrl = 'https://cpsu-test-api.herokuapp.com/api/polls';

  Future<List<Poll>> getAllPoll() async {
    var responseBody = await _makeRequest(
      HttpMethod.get,
      '/',
    );
    List list = responseBody.data;
    return list.map((item) => Poll.fromJson(item)).toList();
  }

  Future<List<ResultPoll>> getIdPoll(int id) async {
    var responseBody = await _makeRequest(
      HttpMethod.get,
      '/$id/results',
    );
    List list = responseBody.data;
    return list.map((item) => ResultPoll.fromJson(item)).toList();
  }

  Future<bool> VoteCheckIn(int id) async {
    var responseBody =
        await _makeRequest(HttpMethod.post, '/$id', {'answer': id});
    bool result = responseBody.data;
    print(
        "โหวตได้แล้ววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววววว");
    return result;
  }
  // todo: สร้างเมธอดสำหรับ request ไปยัง API โดยเรียกใช้เมธอด _makeRequest() ที่อาจารย์เตรียมไว้ให้ด้านล่างนี้
  // ดูตัวอย่างได้จากเมธอด getAllStudents(), getStudentById(), etc. ในโปรเจ็ค class_attendance
  // https://github.com/3bugs/cpsu_class_attendance_frontend/blob/master/lib/services/api.dart

  Future<ResponseBody> _makeRequest(
    HttpMethod httpMethod,
    String path, [
    Map<String, dynamic>? params,
  ]) async {
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Uri? uri;
    http.Response? response;
    var isError = false;

    try {
      switch (httpMethod) {
        // GET method
        case HttpMethod.get:
          String queryString = Uri(queryParameters: params).query;
          uri = Uri.parse('$apiBaseUrl$path?$queryString');

          response = await http.get(
            uri,
            headers: headers,
          );
          break;

        // POST method
        case HttpMethod.post:
          uri = Uri.parse('$apiBaseUrl$path');

          response = await http.post(
            uri,
            headers: headers,
            body: json.encode(params),
          );
          break;
      }
    } catch (e) {
      // ดัก error ที่เกิดขึ้นในกรณียังไม่ได้ response กลับมาจาก API
      // เช่น ไม่มี network connection, server down เป็นต้น

      isError = true;
      _logError(httpMethod, uri, e.toString());
      throw e.toString();
    } finally {
      if (!isError && _isSuccessResponse(response)) {
        debugPrint(
            '┌──────────────────────────────────────────────────────────────────────────────────────────');
        debugPrint(
            '│ ✔ HTTP Method / URL:           ${httpMethod.toShortStringUpperCase()} ${uri.toString()}');
        debugPrint("│ ✔ HTTP Response's Status Code: ${response?.statusCode}");
        debugPrint(
            '└──────────────────────────────────────────────────────────────────────────────────────────');
      }
    }

    ResponseBody? responseBody;
    String? errMessage;
    try {
      // ดักกรณี response body ไม่ได้เป็น JSON

      responseBody = ResponseBody.fromJson(jsonDecode(response.body));
    } catch (e) {
      errMessage = response.body;
    }

    if (_isSuccessResponse(response)) {
      return responseBody!;
    } else {
      // ดัก error กรณีได้ response กลับมาจาก API แล้ว
      // แต่ status code ของ response ไม่ใช่ 200, 201

      var msg = responseBody?.message ?? errMessage ?? 'Unknown Error';
      _logError(
          httpMethod,
          uri,
          responseBody?.message ?? errMessage ?? 'Unknown Error !!!',
          response.statusCode);
      throw msg;
    }
  }

  bool _isSuccessResponse(http.Response? response) {
    return (response?.statusCode == 200 || response?.statusCode == 201);
  }

  void _logError(HttpMethod httpMethod, Uri? uri, String errMessage,
      [int? statusCode]) {
    debugPrint('    ┌───────────┐');
    debugPrint(
        '┌───┤ ⚡ ERROR ⚡ ├──────────────────────────────────────────────────────────────────────────');
    debugPrint('│   └───────────┘');
    debugPrint(
        '│ ✏ HTTP Method / URL:           ${httpMethod.toShortStringUpperCase()} ${uri.toString()}');
    debugPrint(
        "│ ✏ HTTP Response's Status Code: ${statusCode ?? 'N/A (ยังไม่ได้ response จาก API)'}");
    debugPrint('│ ✏ Error Message:               $errMessage');
    debugPrint(
        '└──────────────────────────────────────────────────────────────────────────────────────────');
  }
}
