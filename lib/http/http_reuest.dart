import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// import 'aes.dart';
import 'http_error.dart';

class RequestMethod {
  const RequestMethod._(this.index);

  final index;

  static const RequestMethod GET = RequestMethod._(0);

  static const RequestMethod POST = RequestMethod._(1);

  static const RequestMethod PUT = RequestMethod._(2);

  static const RequestMethod DELETE = RequestMethod._(3);

  static const List<String> _metheds = <String>['GET', 'POST', 'PUT', 'DELETE'];

  @override
  String toString() {
    return _metheds[index];
  }
}

abstract class BasicService<T extends HttpSuccessResponse> {}

class HttpRequest<D extends HttpSuccessResponse> {
  static Dio _dio;
  final String url;
  final RequestMethod method;
  final RequestOption<D> option;

  HttpRequest(this.url,
      {this.method = RequestMethod.GET, @required this.option}) {
    updateDio();
  }

  void updateDio() {
    _dio = Dio(BaseOptions(
      baseUrl: 'Api.HTTP_BASE_URL',
      connectTimeout: 30000,
      receiveTimeout: 30000,
    ));
  }

  Future<D> send(
      {Map<String, dynamic> data = const <String, dynamic>{},
      bool deleteCollect}) async {
    Response response;
    try {
      String sid = await getToken();
      Map<String, dynamic> headers = {
        'S-sid': sid ?? '',
      };
      if (deleteCollect != null && deleteCollect == true) {
        headers[''] = 'DELETE';
      }
      Options opt = Options(headers: headers);

      // LogUtil.v(opt.headers);

      if (method != RequestMethod.GET)
        opt.headers['content-type'] = 'application/x-www-form-urlencoded';

      switch (method) {
        case RequestMethod.GET:
          response = await _dio.get(url, queryParameters: data, options: opt);
          break;
        case RequestMethod.POST:
          response = await _dio.post(url, queryParameters: data, options: opt);
          break;
        case RequestMethod.PUT:
          response = await _dio.put(url, queryParameters: data, options: opt);
          break;
        case RequestMethod.DELETE:
          response =
              await _dio.delete(url, queryParameters: data, options: opt);
          break;
      }
    } on DioError catch (e) {
      if (e.response == null) {
        // DevUtils().toast(' 网络开小差了~  ');
        throw HttpError(' - 网络错误 - ', code: -1);
      }
      throw HttpError(e.toString(), code: -1);
    }

    // LogUtil.v("(${url}）请求结果:    ${response}");
    var result;
    try {
      result = json.decode(response.toString());
    } catch (e) {
      result = response;
    }
    if (result['code'] == 8) {
      ///
      // DevUtils().toast(result['msg'], position: ToastPosition.top ,time: 3000);

      // GlobalEvents.loginOut.add(null);
      return null;
    }

    /// 处理请求数据
    Map<String, dynamic> responseData;
    if (response.headers.toString().contains('application/json')) {
      responseData = response.data;
    } else {
      responseData = json.decode(response.data);
    }
    //LogUtil.v(responseData);
    // var _data = handleData(responseData);

    return option.transform(responseData);
  }

  handleData(Map<String, dynamic> res) {
    dynamic _data;
    return HttpSuccessResponse(
        code: res['code'], data: res['data'] ?? _data, msg: res['msg']);
    // return res['data'];
  }

  Future<String> getToken() async {
    if (option.token != null) {
      return option.token;
    } else {
      // return sidStorage.get();
      return '';
    }
  }
}

class RequestOption<D extends HttpSuccessResponse> {
  final String token;
  final D Function(dynamic data) transform;

  RequestOption({this.token, @required this.transform})
      : assert(transform != null);
}

class HttpSuccessResponse {
  final int code;
  final dynamic data;
  final dynamic msg;
  HttpSuccessResponse({this.code, this.data, this.msg});
}
